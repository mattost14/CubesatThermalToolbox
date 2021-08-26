function orb  = getOrbitalData (sc,sat,attitude,centralBody)

% Constants
sigma = 5.67e-8; % Stefan-Boltzmann constant (W · m -2 · K -4 )

% Time vectors (UTC, Epoch, Julian)
startTimeUTC = datetime(sc.StartTime,"TimeZone","UTC");
stopTimeUTC = datetime(sc.StopTime,"TimeZone","UTC");
time_Epoch = [0:sc.SampleTime:seconds(sc.StopTime - sc.StartTime)]';
time_UTC = [startTimeUTC:seconds(sc.SampleTime):stopTimeUTC]';
time_Julian = juliandate(time_UTC);

% Satellite position x,y,z and velocity xdot, ydot, zdot at ECI (Inertial) frame
[sat_pos_ECI,sat_vel_ECI] = states(sat,'CoordinateFrame', 'inertial'); %m
sat_pos_ECI = (sat_pos_ECI')./1e3; % m -> km
sat_vel_ECI = (sat_vel_ECI')./1e3; % m/s -> km/s

% Sun position x,y,z at ECI (Inertial) frame
sun_pos_ECI = planetEphemeris(time_Julian,'Earth','Sun');

% Moon position x,y,z at ECI (Inertial) frame
moon_pos_ECI = planetEphemeris(time_Julian,'Earth','Moon');

%% Coordinate System Transformation: Earth->Sun (@ECI) to Sat->Sun (@LVLH)
% Frame A:  ECI (Earth Centered Inertial)
% Frame B:  LVLH (Local Vertical, Local Horizontal) (X: R(position), Z: Normal to orbit, Y: cross(Z,X))

% unit vectors
e_lr = sat_pos_ECI./sqrt(sat_pos_ECI(:,1).^2+sat_pos_ECI(:,2).^2+sat_pos_ECI(:,3).^2);  % radial component (LVLH-X)
normal = cross(sat_pos_ECI,sat_vel_ECI);
e_ln = normal./sqrt(normal(:,1).^2+normal(:,2).^2+normal(:,3).^2); % normal component (LVLH-Z)
e_lt = cross(e_ln,e_lr); % tangent component (LVLH-Y)

% origin translation from earth center to satellite center
sun_pos_ECI_satcentered = sun_pos_ECI + sat_pos_ECI;

% X_LVHL = R*X_ECI, where R = [e_lr; e_lt; e_ln]
sun_pos_LVLH_satCentered =  [sun_pos_ECI_satcentered(:,1).*e_lr(:,1)+sun_pos_ECI_satcentered(:,2).*e_lr(:,2)+sun_pos_ECI_satcentered(:,3).*e_lr(:,3),...
                             sun_pos_ECI_satcentered(:,1).*e_lt(:,1)+sun_pos_ECI_satcentered(:,2).*e_lt(:,2)+sun_pos_ECI_satcentered(:,3).*e_lt(:,3),...
                             sun_pos_ECI_satcentered(:,1).*e_ln(:,1)+sun_pos_ECI_satcentered(:,2).*e_ln(:,2)+sun_pos_ECI_satcentered(:,3).*e_ln(:,3)];
                   
% Unit vector sat->sun in the LVLH frame
sat2sun_LVLH = sun_pos_LVLH_satCentered./sqrt(sun_pos_LVLH_satCentered(:,1).^2+sun_pos_LVLH_satCentered(:,2).^2+sun_pos_LVLH_satCentered(:,3).^2);

%% Eclipse check calculation
distance_Sat2EarthCenter = sqrt(sat_pos_ECI(:,1).^2+sat_pos_ECI(:,2).^2+sat_pos_ECI(:,3).^2); % (km)
altitude = distance_Sat2EarthCenter - earthRadius/1e3;
thetaSat2EarthTangent = asind((earthRadius/1e3)./distance_Sat2EarthCenter);

calculateAngleBetweenVectors = @(u,v) acosd(max(min(dot(u,v)/(norm(u)*norm(v)),1),-1)); % function that return angle between two vectors in degrees

sunMagnitude = ones(length(time_Epoch),1);
for i=1:length(time_Epoch)
    angle_Sat2Sun_Sat2Earth = calculateAngleBetweenVectors(sat2sun_LVLH(i,:),[-1,0,0]);
    if angle_Sat2Sun_Sat2Earth > thetaSat2EarthTangent(i)
        sunMagnitude(i) = 1;
    else 
        sunMagnitude(i) = 0;
    end
end

%% Sun intensity at each face

sunMagnitudeXfaces = zeros(length(time_Epoch),1);
sunMagnitudeYfaces = zeros(length(time_Epoch),1);
sunMagnitudeZfaces = zeros(length(time_Epoch),1);

% Considering rotations from the default sallite orientation for NADIR
% fixed
rotmZYX = angle2dcm(deg2rad(attitude.rotationAboutZ), deg2rad(attitude.rotationAboutY), deg2rad(attitude.rotationAboutX),'ZYX');
rotmInitial = [0 1 0;0 0 1;1 0 0];
XfaceVector_LVLH = rotmInitial'*rotmZYX'*[1 0 0]';
YfaceVector_LVLH = rotmInitial'*rotmZYX'*[0 1 0]';
ZfaceVector_LVLH = rotmInitial'*rotmZYX'*[0 0 1]';

for i=1:length(time_Epoch)
    angle_faceXNormal_Sun = calculateAngleBetweenVectors(sat2sun_LVLH(i,:),XfaceVector_LVLH);
    angle_faceYNormal_Sun = calculateAngleBetweenVectors(sat2sun_LVLH(i,:),YfaceVector_LVLH);
    angle_faceZNormal_Sun = calculateAngleBetweenVectors(sat2sun_LVLH(i,:),ZfaceVector_LVLH);
    sunMagnitudeXfaces(i) = cosd(angle_faceXNormal_Sun)*sunMagnitude(i);
    sunMagnitudeYfaces(i) = cosd(angle_faceYNormal_Sun)*sunMagnitude(i);
    sunMagnitudeZfaces(i) = cosd(angle_faceZNormal_Sun)*sunMagnitude(i); 
end

solarLight = [time_Epoch, ...
              max(sunMagnitudeXfaces,0),...
              max(-sunMagnitudeXfaces,0),...
              max(sunMagnitudeYfaces,0),...
              max(-sunMagnitudeYfaces,0),...
              max(sunMagnitudeZfaces,0),...
              max(-sunMagnitudeZfaces,0),...
              sunMagnitude];
          
solarLight = array2table(solarLight);
solarLight.Properties.VariableNames = {'time','x_plus_magnitude','x_minus_magnitude','y_plus_magnitude','y_minus_magnitude', 'z_plus_magnitude', 'z_minus_magnitude','magnitude'};
solarLight.time = seconds(solarLight.time);
solarLight = table2timetable(solarLight);

orb.solarLight = solarLight;

%% IR and Albedo

% Albedo Angle: angle(Earth->Sat, Earth->Sun)
AlbedoAngle_deg_ = zeros(length(time_Epoch),1);
satLat_deg = zeros(length(time_Epoch),1);
for i=1:length(time_Epoch)
    AlbedoAngle_deg_(i) = calculateAngleBetweenVectors(sat_pos_ECI(i,:), sun_pos_ECI(i,:));
    %Calculating satellite underneath latitude
    satLat_deg(i) = 90-calculateAngleBetweenVectors(sat_pos_ECI(i,:), [0,0,1]);
end
albedoAngle(:,1) = time_Epoch;
albedoAngle(:,2) = AlbedoAngle_deg_;
albedoAngle = array2table(albedoAngle);
albedoAngle.Properties.VariableNames = {'time','AlbedoAngle_deg_'};
albedoAngle.time = seconds(albedoAngle.time);
albedoAngle = table2timetable(albedoAngle);

if(isfield(getCentralBodyProperties(centralBody),'albedoFactorByLatitudeTable'))
    albedoFactorByLatitude = load(getCentralBodyProperties(centralBody).albedoFactorByLatitudeTable, 'data');
    albedoFactorByLatitude = albedoFactorByLatitude.data;
    albedoFactor = zeros(length(time_Epoch),1);
    for i=1:length(time_Epoch)
        albedoFactor(i) = interp1(albedoFactorByLatitude.Lat, albedoFactorByLatitude.Albedo, satLat_deg(i), 'nearest');
    end
else
    albedoFactor = getCentralBodyProperties(centralBody).albedoFactor;
end

orb.albedoAngle = albedoAngle;
orb.albedoFactor = albedoFactor;

%%% Planetary IR Power
daytime = (AlbedoAngle_deg_ - 90 < 0);
orb.Pir = daytime*sigma*(getCentralBodyProperties(centralBody).Tir_Day)^4 + (1-daytime)*sigma*(getCentralBodyProperties(centralBody).Tir_Night)^4; % Central body radiation

%%% View factor
phi_deg = acosd((earthRadius/1e3)./distance_Sat2EarthCenter); % Limb angle (deg)

% Angle between Face Normal with Nadir Vector
nadirVector_LVLH = [-1 0 0];
Xface2NadirAngle_deg = ones(length(time_Epoch),1)*calculateAngleBetweenVectors(XfaceVector_LVLH,nadirVector_LVLH);
Yface2NadirAngle_deg = ones(length(time_Epoch),1)*calculateAngleBetweenVectors(YfaceVector_LVLH,nadirVector_LVLH);
Zface2NadirAngle_deg = ones(length(time_Epoch),1)*calculateAngleBetweenVectors(ZfaceVector_LVLH,nadirVector_LVLH);

calculateViewFactor = @(alpha, phi) (cos(phi)).^2 .* max(0, cos((pi/2)*(alpha./(pi-phi)))).^2.5; %alpha: FaceNormal to Nadir angle (rad), phi: limb angle (rad)

viewFactor(:,1) = time_Epoch;
viewFactor(:,2) = calculateViewFactor(deg2rad(Xface2NadirAngle_deg), deg2rad(phi_deg));
viewFactor(:,3) = calculateViewFactor(deg2rad(180-Xface2NadirAngle_deg), deg2rad(phi_deg));
viewFactor(:,4) = calculateViewFactor(deg2rad(Yface2NadirAngle_deg), deg2rad(phi_deg));
viewFactor(:,5) = calculateViewFactor(deg2rad(180-Yface2NadirAngle_deg), deg2rad(phi_deg));
viewFactor(:,6) = calculateViewFactor(deg2rad(Zface2NadirAngle_deg), deg2rad(phi_deg));
viewFactor(:,7) = calculateViewFactor(deg2rad(180-Zface2NadirAngle_deg), deg2rad(phi_deg));

viewFactor = array2table(viewFactor);
viewFactor.Properties.VariableNames = {'time','x_plus','x_minus','y_plus','y_minus', 'z_plus', 'z_minus'};
viewFactor.time = seconds(viewFactor.time); 
viewFactor = table2timetable(viewFactor);
orb.viewFactor = viewFactor;


%% Store main orbital data as table (to compare with STK report outputs)
varNames = {'Time_EpSec_','time_UTC',...
            'x_Magnitude','y_Magnitude','z_Magnitude','Magnitude',...
            'DirectionAngleX_deg_','DirectionAngleY_deg_','DirectionAngleZ_deg_',...
            'Alt_km_','AlbedoAngle_deg_'};
orbitalData = table(time_Epoch,time_UTC, ...
                    sunMagnitudeXfaces,sunMagnitudeYfaces,sunMagnitudeZfaces, sunMagnitude,...
                    Xface2NadirAngle_deg, Yface2NadirAngle_deg, Zface2NadirAngle_deg,...
                    altitude, AlbedoAngle_deg_,...
                    'VariableNames',varNames);
orbitalData.Time_EpSec_ = seconds(orbitalData.Time_EpSec_);
orb.orbitalData = orbitalData;
end


