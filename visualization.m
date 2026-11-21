%% Visualization 
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

% Figure 2.2: Recovery Time Distribution
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