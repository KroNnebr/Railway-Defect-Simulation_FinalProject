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