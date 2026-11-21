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