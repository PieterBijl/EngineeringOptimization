function PlotStates(names, states, timestep)
% Made by Toon Stolk and Pieter Bijl as part of the course Engineering Optimization
% at Delft University of Technology
%
% PlotStates.m
% The PlotStates function provides a framework in which a the states of
% the powerplants (fractions of the powerplants) can be presented in a
% single plot over time.
%
% Input:
% names: a n x 2 matrix with the names and colors of the different power
% plants.
% states: a n x t matrix in which the states are described over a certain
% time period.
% timestep: an integer that gives the timestep op the algorithm in hours.
% 
% Dependencies:
% None

% Set up the dates between which the data is presented
startDate = datetime('today');
endDate = datetime('today')+hours(timestep*length(states'));
dates = linspace(startDate, endDate, length(states'));

% plot the states in colors specified in names
figure
h = area(dates, states');
for i = 1:length(names(:,2))
    h(i).FaceColor = cell2mat(names(i,2));
end
datetick('x','yyyy','keepticks')
xlabel("Time")
ylim([0 1])
ylabel("Fraction of total power supply")

% Set location and size of figure
x0=50;
y0=50;
width=700;
height=400;
set(gcf,'position',[x0,y0,width,height])

legend(names(:,1), 'Location', 'eastoutside')
end