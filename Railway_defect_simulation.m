%Railway defect simulation
%{
    Project Title: Monte Carlo Simulation of Railway Defect Effects 
                   on Train Delays and Return-to-Operation Time
    Course: CS0019 - Modeling and Simulation (FEU Tech)
    Members:
    Austria, Brianne Paolo
    Cuarentas, Justin Kurt
    Fojas, Franz Erich
    Francisco, Hans Eleazar
    Description: Baseline structural script for Monte Carlo simulation 
                 comparing Normal, Moderate, and Severe railway scenarios.
%}

clear; clc; close all;

%% 1. Simulation Configuration
numSimulations = 1000; % Number of Monte Carlo runs
simulationHours = 24;  % Operating hours represented by each run

% Stochastic network/traffic assumptions.
% These are explicit assumptions and can be replaced with observed railway data.
network.baseArrivalRate = 18;       % Average arriving trains per hour
network.baseServiceRate = 20;       % Trains that can normally be processed/hour
network.serviceVariation = 0.10;    % Random variation in hourly service capacity
network.queueDelayPerTrain = 2;     % Additional delay (minutes) per queued train

% Define Scenario Parameters (Assumed initial baseline parameters for framework)
% Format: [Defect Probability, Mean Delay (mins), Mean Recovery Time (hrs)]
scenarios = struct();
% serviceMultiplier reduces processing capacity while a defect is active.
% arrivalMultiplier represents heavier traffic under more disruptive conditions.
scenarios.Normal   = struct('prob', 0.05, 'delayRate', 5, 'recoveryRate', 2, ...
    'serviceMultiplier', 0.90, 'arrivalMultiplier', 1.00);
scenarios.Moderate = struct('prob', 0.20, 'delayRate', 25, 'recoveryRate', 6, ...
    'serviceMultiplier', 0.70, 'arrivalMultiplier', 1.10);
scenarios.Severe   = struct('prob', 0.50, 'delayRate', 60, 'recoveryRate', 18, ...
    'serviceMultiplier', 0.45, 'arrivalMultiplier', 1.20);

scenarioNames = {'Normal', 'Moderate', 'Severe'};
results = struct();

%% 2. Monte Carlo Simulation Loop
rng(42); % Set random seed for reproducibility

fieldNames = fieldnames(scenarios);
for i = 1:length(fieldNames)
    scenName = fieldNames{i};
    p = scenarios.(scenName).prob;
    dMean = scenarios.(scenName).delayRate;
    rMean = scenarios.(scenName).recoveryRate;
    serviceMultiplier = scenarios.(scenName).serviceMultiplier;
    arrivalMultiplier = scenarios.(scenName).arrivalMultiplier;

    delays = zeros(numSimulations, 1);
    recoveries = zeros(numSimulations, 1);
    directDelays = zeros(numSimulations, 1);
    congestionDelays = zeros(numSimulations, 1);
    peakQueues = zeros(numSimulations, 1);
    averageQueues = zeros(numSimulations, 1);
    congestionIndexes = zeros(numSimulations, 1);
    queueHistory = zeros(numSimulations, simulationHours);

    for sim = 1:numSimulations
        % Simulate defect occurrence using Bernoulli/Uniform trial
        defectOccurred = rand() < p;

        if defectOccurred
            % Using exponential or normal sampling for positive skewed operational data
            directDelays(sim) = max(0, dMean + randn() * (dMean * 0.2));
            recoveries(sim) = max(0, rMean + randn() * (rMean * 0.2));
        else
            directDelays(sim) = 0;
            recoveries(sim) = 0;
        end

        % Simulate arrivals and departures hour by hour. A defect reduces
        % service capacity for the sampled recovery window, causing a queue
        % to build when arrivals exceed available processing capacity.
        queueLength = 0;
        activeHours = min(simulationHours, max(0, ceil(recoveries(sim))));
        for hour = 1:simulationHours
            arrivals = poissonSample(network.baseArrivalRate * arrivalMultiplier);
            serviceRate = network.baseServiceRate;

            if defectOccurred && hour <= activeHours
                serviceRate = serviceRate * serviceMultiplier;
            end

            availableService = max(0, round(serviceRate * ...
                (1 + randn() * network.serviceVariation)));
            queueLength = max(0, queueLength + arrivals - availableService);
            queueHistory(sim, hour) = queueLength;
        end

        peakQueues(sim) = max(queueHistory(sim, :));
        averageQueues(sim) = mean(queueHistory(sim, :));
        congestionIndexes(sim) = min(1, averageQueues(sim) / network.baseServiceRate);
        congestionDelays(sim) = averageQueues(sim) * network.queueDelayPerTrain;
        delays(sim) = directDelays(sim) + congestionDelays(sim);
    end

    results.(scenName).delays = delays;
    results.(scenName).directDelays = directDelays;
    results.(scenName).congestionDelays = congestionDelays;
    results.(scenName).recoveries = recoveries;
    results.(scenName).peakQueues = peakQueues;
    results.(scenName).averageQueues = averageQueues;
    results.(scenName).congestionIndexes = congestionIndexes;
    results.(scenName).queueHistory = queueHistory;
    results.(scenName).avgDelay = mean(delays);
    results.(scenName).avgDirectDelay = mean(directDelays);
    results.(scenName).avgCongestionDelay = mean(congestionDelays);
    results.(scenName).avgRecovery = mean(recoveries);
    results.(scenName).avgPeakQueue = mean(peakQueues);
    results.(scenName).avgQueue = mean(averageQueues);
    results.(scenName).avgCongestionIndex = mean(congestionIndexes);
end

disp('Monte Carlo simulation structural runs completed successfully.');

%% 3. Planned Outputs Placeholder (Metrics Summary)
fprintf('\n--- SIMULATION SUMMARY RESULTS ---\n');
for i = 1:length(scenarioNames)
    s = scenarioNames{i};
    fprintf('Scenario: %s\n', s);
    fprintf('  -> Average Train Delay: %.2f mins\n', results.(s).avgDelay);
    fprintf('     Direct Defect Delay: %.2f mins\n', results.(s).avgDirectDelay);
    fprintf('     Congestion Delay: %.2f mins\n', results.(s).avgCongestionDelay);
    fprintf('  -> Average Return-to-Operation Time: %.2f hours\n', results.(s).avgRecovery);
    fprintf('  -> Average Peak Queue: %.2f trains\n', results.(s).avgPeakQueue);
    fprintf('  -> Average Queue Length: %.2f trains\n', results.(s).avgQueue);
    fprintf('  -> Average Congestion Index: %.2f\n', results.(s).avgCongestionIndex);
end

%% 4. Visualization Framework (Plots for Evaluation)
% Figure 1: Bar Graph Comparison of Averages
figure('Name', 'Scenario Comparison - Averages', 'Color', 'white');
avgDelays = [results.Normal.avgDelay, results.Moderate.avgDelay, results.Severe.avgDelay];
avgRecoveries = [results.Normal.avgRecovery, results.Moderate.avgRecovery, results.Severe.avgRecovery];

subplot(1,2,1);
bar(categorical({'Normal', 'Moderate', 'Severe'}), avgDelays, 'FaceColor', '#0072BD');
title('Average Train Delay Duration');
ylabel('Minutes');
grid on;

subplot(1,2,2);
bar(categorical({'Normal', 'Moderate', 'Severe'}), avgRecoveries, 'FaceColor', '#D95319');
title('Average Return-to-Operation Time');
ylabel('Hours');
grid on;

% Figure 2.1: Train Delay Distribution
figure('Name', 'Histogram Distributions', 'Color', 'white');

subplot(1,2,1);
histogram(results.Normal.delays, 20, 'DisplayName', 'Normal', 'FaceAlpha', 0.5);
hold on;

histogram(results.Moderate.delays, 20, 'DisplayName', 'Moderate', 'FaceAlpha', 0.5);

histogram(results.Severe.delays, 20, 'DisplayName', 'Severe', 'FaceAlpha', 0.5);

title('Distribution of Train Delay Duration');
xlabel('Delay Duration (minutes)');
ylabel('Frequency');
legend('Location', 'best');
grid on;
hold off;

% Figure 2.2: % Right: Recovery Time Distribution
subplot(1,2,2);
histogram(results.Normal.recoveries, 20, 'DisplayName', 'Normal', 'FaceAlpha', 0.5);
hold on;

histogram(results.Moderate.recoveries, 20, 'DisplayName', 'Moderate', 'FaceAlpha', 0.5);

histogram(results.Severe.recoveries, 20, 'DisplayName', 'Severe', 'FaceAlpha', 0.5);
title('Distribution of Recovery Time');
xlabel('Return-to-Operation Time (hours)');
ylabel('Frequency');
legend('Location', 'best');
grid on;
hold off;

%% 5. Local stochastic helper
function count = poissonSample(lambda)
%POISSONSAMPLE Generate a Poisson random count without requiring a toolbox.
    if lambda <= 0
        count = 0;
        return;
    end

    threshold = exp(-lambda);
    product = 1;
    count = 0;
    while product > threshold
        count = count + 1;
        product = product * rand();
    end
    count = count - 1;
end
