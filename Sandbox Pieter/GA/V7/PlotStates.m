function PlotStates(names, states, timestep) 

startDate = datetime('today');
endDate = datetime('today')+hours(timestep*length(states'));
dates = linspace(startDate, endDate, length(states'));

figure
area(dates, states')
datetick('x','yyyy','keepticks')
xlabel("Time")
ylim([0 1])
ylabel("Fraction of total power supply")

% Set location and size of figure
x0=50;
y0=300;
width=700;
height=400;
set(gcf,'position',[x0,y0,width,height])

legend(names(:,1),'Location', 'eastoutside')

end