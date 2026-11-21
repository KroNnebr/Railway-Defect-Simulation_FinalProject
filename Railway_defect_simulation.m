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

% Define Scenario Parameters (Assumed initial baseline parameters for framework)
% Format: [Defect Probability, Mean Delay (mins), Mean Recovery Time (hrs)]
scenarios = struct();
scenarios.Normal   = struct('prob', 0.05, 'delayRate', 5,  'recoveryRate', 2);
scenarios.Moderate = struct('prob', 0.20, 'delayRate', 25, 'recoveryRate', 6);
scenarios.Severe   = struct('prob', 0.50, 'delayRate', 60, 'recoveryRate', 18);

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

    delays = zeros(numSimulations, 1);
    recoveries = zeros(numSimulations, 1);

    for sim = 1:numSimulations
        % Simulate defect occurrence using Bernoulli/Uniform trial
        defectOccurred = rand() < p;

        if defectOccurred
            % Using exponential or normal sampling for positive skewed operational data
            delays(sim) = max(0, dMean + randn() * (dMean * 0.2));
            recoveries(sim) = max(0, rMean + randn() * (rMean * 0.2));
        else
            delays(sim) = 0;
            recoveries(sim) = 0;
        end
    end

    results.(scenName).delays = delays;
    results.(scenName).recoveries = recoveries;
    results.(scenName).avgDelay = mean(delays);
    results.(scenName).avgRecovery = mean(recoveries);
end

disp('Monte Carlo simulation structural runs completed successfully.');

%% 3. Planned Outputs Placeholder (Metrics Summary)
fprintf('\n--- SIMULATION SUMMARY RESULTS ---\n');
for i = 1:length(scenarioNames)
    s = scenarioNames{i};
    fprintf('Scenario: %s\n', s);
    fprintf('  -> Average Train Delay: %.2f mins\n', results.(s).avgDelay);
    fprintf('  -> Average Return-to-Operation Time: %.2f hours\n', results.(s).avgRecovery);
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

%% 5. Line Graphs (Advanced Visualization)
colors = {'#0072BD', '#EDB120', '#D95319'};
n = (1:numSimulations)';
window = 50;   % moving average window size

% Figure 3: Running average across simulation runs
figure('Name', 'Running Average Convergence', 'Color', 'white');

subplot(1,2,1); hold on;
for i = 1:length(scenarioNames)
    s = scenarioNames{i};
    plot(n, cumsum(results.(s).delays) ./ n, 'LineWidth', 1.5, ...
        'Color', colors{i}, 'DisplayName', s);
end
title('Running Average of Train Delay');
xlabel('Number of Simulations'); ylabel('Average Delay (minutes)');
legend('Location', 'best'); grid on; hold off;

subplot(1,2,2); hold on;
for i = 1:length(scenarioNames)
    s = scenarioNames{i};
    plot(n, cumsum(results.(s).recoveries) ./ n, 'LineWidth', 1.5, ...
        'Color', colors{i}, 'DisplayName', s);
end
title('Running Average of Return-to-Operation Time');
xlabel('Number of Simulations'); ylabel('Average Recovery (hours)');
legend('Location', 'best'); grid on; hold off;

% Figure 4: Moving average (local trend across runs)
figure('Name', 'Moving Average Trend', 'Color', 'white');

subplot(1,2,1); hold on;
for i = 1:length(scenarioNames)
    s = scenarioNames{i};
    plot(n, movmean(results.(s).delays, window), 'LineWidth', 1.5, ...
        'Color', colors{i}, 'DisplayName', s);
end
title(sprintf('Moving Average of Train Delay (window = %d)', window));
xlabel('Simulation Run'); ylabel('Delay (minutes)');
legend('Location', 'best'); grid on; hold off;

subplot(1,2,2); hold on;
for i = 1:length(scenarioNames)
    s = scenarioNames{i};
    plot(n, movmean(results.(s).recoveries, window), 'LineWidth', 1.5, ...
        'Color', colors{i}, 'DisplayName', s);
end
title(sprintf('Moving Average of Recovery Time (window = %d)', window));
xlabel('Simulation Run'); ylabel('Recovery (hours)');
legend('Location', 'best'); grid on; hold off;