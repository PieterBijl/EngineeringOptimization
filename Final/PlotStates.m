function PlotStates(names, states, timestep) 

startDate = datetime('today');
endDate = datetime('today')+hours(timestep*length(states'));
dates = linspace(startDate, endDate, length(states'));

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