
%% Plot comparison
function plotTempComparison(output1, output2, name1, name2)
    figure ()
    load(output1)
    plot(hours(T.time), T.P - 273.15, 'LineWidth', 2, 'DisplayName', name1); 
    hold on

    load(output2)
    plot(hours(T.time), T.P - 273.15,  'LineWidth', 2, 'DisplayName', name2);

    ylabel('Temp (C)')
    xlabel('Epoch (H)')
    grid on
    legend
    set(gca,'FontSize',16)
end