function T = runThermalAnalysis (param)
    %% Run ODE45 to solve system of nonlinear ODE's
    tspan = seconds(param.orbitalData.Time_EpSec_)';
    X0 = ones(7,1)*300; % Initial node's temperatures
    figure()
    options = odeset('Stats','off','RelTol',1e-3,'AbsTol',1e-4, 'OutputFcn',@odeplot);
    disp('Running thermal analysis... Please wait.');
    tic
    [t,y] = ode45(@(t,X) funODE45(t,X, param), tspan, X0, options);
    elapsedTime = toc;
    [h,m,s] = hms(seconds(elapsedTime));
    msg = sprintf("Thermal analysis completed in %d:%d:%d", h, m, round(s));
    disp(msg);

    T = array2table([t,y]);
    T.Properties.VariableNames = {'time','x_plus','x_minus','y_plus','y_minus','z_plus', 'z_minus', 'P'};
    T.time = seconds(T.time);
    T = table2timetable(T);
    T = synchronize(T,param.solarLight,'first','spline');
end