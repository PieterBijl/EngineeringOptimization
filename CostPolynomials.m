% This matlab files describes different polynomial functions that 
% describe the cost in terms of money and CO2 emitted for different
% sources of energy.

clc; clear all; close all;

% The energy sources considered are: Coal, Oil, Gas, Hydro, Wind, Solar,
% Nuclear & Biomass
% Possible extra sources could be: Geothermal

% List of possible sources
sources = ["Coal"; "Oil"; "Gas"; "Hydro"; "Wind"; "Solar"; "Nuclear"; "Biomass"];

% List of polynomial coefficients that describe the relative cost
% i.e. gas is twice as expensive as coal
moneypoly = [0, 0, 1; 0, 0, 1.5; 0, 0, 2; 0, 0, 3; 0, 0, 3; 0, 0, 2; 0, 0, 5; 0, 0, 2];
moneyCoal = [0, 0, 1];
moneyGas = [0, 0, 1.5];

% Evaluate the data needed to plot the polynomials for different sources.
coal = zeros(1, 101);
gas = zeros(1, 101);
percentages = zeros(1, 101);
for i = 0:100
    percentages(i+1) = i/100;
    coal(i+1) = polyval(moneyCoal, i/100);
    gas(i+1) = polyval(moneyGas, i/100);
end

% Plot the specific polynomials of the different sources.
plot(percentages, coal, percentages, gas)
xlim([0 1])
ylim([0 10])
legend(sources(1:2))

