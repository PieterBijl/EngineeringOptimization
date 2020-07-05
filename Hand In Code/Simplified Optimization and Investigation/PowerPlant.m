function [powerplants, cost, carbon] = PowerPlant()
% Made by Toon Stolk and Pieter Bijl as part of the course Engineering Optimization
% at Delft University of Technology
% 
% PowerPlant.m
% PowerPlant.m is a function that reads a table of data specified in an
% excel sheet. The data contains different energy sources and its
% associated capital costs, maintenance costs and fuel costs.
% Dependencies:
% Power Plant Data.xlsx

    % Specify filename, change when necessary (do note the format to run
    % the program smoothly)
    filename = 'Power Plant Data.xlsx';
    dataTable = readtable(filename);

    data = table2array(dataTable(:,2:5));

    powerplants = table2array(dataTable(:,1));
    cost = zeros(height(dataTable),2);
    carbon = zeros(height(dataTable),1);
    for i = 1:height(dataTable)
        cost(i,1) = data(i,1);                      % Capital costs ($/kW)
        cost(i,2) = data(i,2)/365/24 + data(i,3);   % Variable costs (maintenance + fuel cost) ($/kWh)
        carbon(i,1) = data(i,4);                    % Carbon emission (kg CO2/kWh)
    end
end