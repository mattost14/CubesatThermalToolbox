clear all
close all
clc


%% Load simulation parameters
disp('Generating simulation parameters...');
[param, opt] = getSimulationParameters();

%% Plot satellite to confirm faces material and orietation
figure()
plotCubesat(param)
disp('Plot 1 - Check the faces material and orientation on the plot.');


%% Plot power profile
disp('Plot 2 - Check power profile and power balance.');
figure()
subplot(2,1,1)
plot(seconds(param.powerProfile.time), param.powerProfile.internalPower, 'LineWidth',2)
xlabel('Epoch time (s)')
ylabel('Power Consumption (W)');
title('Power Profile')
grid on

subplot(2,1,2)
plot(seconds(param.powerProfile.time), -param.energyDrawnFromBat_Wh, 'LineWidth',2)
xlabel('Epoch time (s)')
ylabel('Energy drawn from battery - relative to its capacity (Wh)');
title('Battery charge/discharge profile')
grid on

%% Show satellite in orbit
if(opt.showOrbitalAnimation)
    show(param.sat)
    play(param.sc)
end

userInput = input('Press ''Enter'' to continue...');
%% Run Thermal Analysis
if(opt.thermalAnalysis)
    T = runThermalAnalysis(param);
end

%% Power Generation Analysis
if(opt.powerAnalysis)
    P = runPowerAnalysis(param);
end

%% Save Result

filePath = strcat('Output/',param.simulationName,'_orb_',opt.orbit,'_mode',num2str(opt.mode),'_out','.mat');
disp(strcat('Results saved in ~/', filePath));
if(opt.thermalAnalysis && opt.powerAnalysis)
    save(filePath, 'T', 'P')
elseif(opt.thermalAnalysis)
      save(filePath, 'T')
elseif(opt.powerAnalysis)
    save(filePath, 'P')
end

%% Plotting
plotResultsFromOutputMATfile(filePath);

