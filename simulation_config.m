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