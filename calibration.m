clear all
% close all
% clc

run('inputs.m')

[param, opt] = getSimulationParameters();

i=6; % X+

Fir=param.viewFactor.(i);
Pir=param.Pir;
Falb = Fir.*max(0, cosd(param.albedoAngle.AlbedoAngle_deg_));

figure()
plot(param.solarLight.(i).*param.solarFlux,'DisplayName','Direct','LineWidth',2)
ylim([0 1600])
hold on
yyaxis right
IR = Fir .* Pir;
plot(IR,'DisplayName','IR','LineWidth',2,'color','k')
albedo = Falb.* param.solarLight.magnitude.*param.solarFlux.*param.albedoFactor;
plot(albedo,'DisplayName','Albedo','LineWidth',2, 'color', 'b')
ylim([0 400])

set(gca,'FontSize',16)
grid on


time = seconds(param.solarLight.time);
directSunEnergy = trapz(time, param.solarLight.(i).*param.solarFlux)/time(end);
IRenergy = trapz(time, IR)/time(end);
albedoEnergy = trapz(time, albedo)/time(end);

disp(sprintf('Direct sunlight: %.2f W/m2', directSunEnergy))
disp(sprintf('Earth IR: %.2f W/m2', IRenergy))
disp(sprintf('Earth Albedo: %.2f W/m2', albedoEnergy))