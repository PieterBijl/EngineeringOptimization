    function [powerplants, cost, carbon] = PowerPlant()
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