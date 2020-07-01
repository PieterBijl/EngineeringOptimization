function PlotStates(names, states, timestep) 
time2 = datetime('today') + caldays(1:floored(length(states)*timestep/24);

figure
area(time2, states')
xlabel("Time")
% ylim([0 1])
ylabel("Fraction of total power supply")

legend(names(:))
end