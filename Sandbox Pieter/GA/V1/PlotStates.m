function PlotStates(names, states, timestep) 
time2 = datetime('today') + caldays(1:length(states));

figure
area(time2, states')
xlabel("Time")
% ylim([0 1])
ylabel("Fraction of total power supply")

legend(names(:))
end