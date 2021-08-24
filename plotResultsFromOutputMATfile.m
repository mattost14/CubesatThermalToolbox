%% Plotting

function plotResultsFromOutputMATfile(fileName)
    load(fileName,'T');
    R=T;
    figure ()
    Rtable =timetable2table(R);
    plot(hours(R.time),table2array(Rtable(:,2:8))-273.14, 'LineWidth', 2)
    legend('X+','X-','Y+','Y-','Z+','Z-','Internal');
    grid on
    xlabel('Epoch Time (hours)')
    ylabel('Temp (C)')
    set(gca,'FontSize',16)


    figure()

    subplot(6,1,1)
    title('Face X+ Temperature')
    plot(R.time, R.x_plus - 273.15,'LineWidth', 2); hold on
    ylabel('Temp (C)')
    yyaxis right
    plot(R.time, R.x_plus_magnitude,'LineWidth', 2)
    ylim([0 1])
    grid on
    title('X+')

    subplot(6,1,2)
    plot(R.time, R.x_minus - 273.15,'LineWidth', 2); hold on
    ylabel('Temp (C)')
    yyaxis right
    plot(R.time, R.x_minus_magnitude,'LineWidth', 2)
    ylim([0 1])
    grid on
    title('X-')

    subplot(6,1,3)
    plot(R.time, R.y_plus - 273.15,'LineWidth', 2); hold on
    ylabel('Temp (C)')
    yyaxis right
    plot(R.time, R.y_plus_magnitude,'LineWidth', 2)
    ylim([0 1])
    grid on
    title('Y+')

    subplot(6,1,4)
    plot(R.time, R.y_minus - 273.15,'LineWidth', 2); hold on
    ylabel('Temp (C)')
    yyaxis right
    plot(R.time, R.y_minus_magnitude,'LineWidth', 2)
    ylim([0 1])
    grid on
    title('Y-')

    subplot(6,1,5)
    plot(R.time, R.z_plus - 273.15,'LineWidth', 2); hold on
    ylabel('Temp (C)')
    yyaxis right
    plot(R.time, R.z_plus_magnitude,'LineWidth', 2)
    ylim([0 1])
    grid on
    title('Z+')

    subplot(6,1,6)
    plot(R.time, R.z_minus - 273.15,'LineWidth', 2); hold on
    ylabel('Temp (C)')
    yyaxis right
    plot(R.time, R.z_minus_magnitude,'LineWidth', 2)
    ylim([0 1])
    grid on
    title('Z-')

    figure()
    plot(hours(R.time), R.P - 273.15, 'LineWidth', 2); hold on
    ylabel('Temp (C)')
    xlabel('Epoch Time (hours)')
    yyaxis right
    plot(hours(R.time), R.magnitude,'LineWidth', 2)
    ylim([0 1])
    ylabel('Sun light')
    title('Internal Temperature')
    grid on
    set(gca,'FontSize',16)
end