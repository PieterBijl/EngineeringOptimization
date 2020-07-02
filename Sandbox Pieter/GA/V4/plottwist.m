

% Plot the reaction of the power plant

[names, costs, carbon] = PowerPlant();

PlotPowerPlant(names, costs, carbon, 24, 20)

function PlotPowerPlant(names, costs, carbon, timestep, loanDuration)
    % timestep in hours and loanDuration in years
    
    power = zeros(1,1001);
    costPerkWh = zeros(length(names),1001);
    carbonEmission = zeros(length(names),1001);
    for i = 0:1000
        power(i+1) = i;
        costPerkWh(:,i+1) = i * costs(:,1) * timestep + timestep * costs(:,2)/loanDuration;
        
        carbonEmission(:,i+1) = i * carbon(:,1);
    end
    
    yyaxis left
    plot(power, costPerkWh(1,:))
    xlabel('Power (kWh)')
    
    yyaxis right
    plot(power, carbonEmission(1,:))
    
end