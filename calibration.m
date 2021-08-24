close all
clc

i=1; % X+

Fir=param.viewFactor.(i);
Pir=param.Pir;
Falb = Fir.*max(0, cosd(param.albedoAngle.AlbedoAngle_deg_));

figure()
plot(param.solarLight.(i).*param.solarFlux,'DisplayName','Direct','LineWidth',2)
ylim([0 1600])
hold on
yyaxis right
plot(Fir .* Pir,'DisplayName','IR','LineWidth',2,'color','k')
plot(Falb.* param.solarLight.magnitude.*param.solarFlux.*param.albedoFactor,'DisplayName','Albedo','LineWidth',2, 'color', 'b')
ylim([0 400])

set(gca,'FontSize',16)
grid on