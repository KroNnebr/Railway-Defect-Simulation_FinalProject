% Railway defect simulation
%
% Main program that runs the different modules of the
% railway defect Monte Carlo simulation in order.
%
% The simulation itself is divided into separate scripts
% to make the project easier to document and maintain.
%
% Module order:
%   1. simulation_config.m
%   2. monte_carlo_simulation.m
%   3. display_results.m
%   4. visualization.m

clear; clc; close all;

run('simulation_config.m');
run('monte_carlo_simulation.m');
run('display_results.m');
run('visualization.m');