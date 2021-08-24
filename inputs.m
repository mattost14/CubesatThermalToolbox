%% INPUTS

%% 1- SIMULATION
simulationName = "NAPA-1";
opt.thermalAnalysis = 1; % boolean
opt.powerAnalysis = 0; % boolean

%% 2 - SATELLITE INFO

satName = "NAPA-1";
numberOfUnits = 6; % options: 1, 3, 6, 12
satelliteMass = 6.8; % kg

% Choose the predomenant material type for each face
% Options: "goldCoating", "solarCell", "whiteCoating", "blackCoating"
% Check the getPropertiesFromMaterial.m file to see/edit thermal properties for each material
% Xplus_faceMaterial = "goldCoating";
% Xminus_faceMaterial = "whiteCoating";
% Yplus_faceMaterial = "solarCell";
% Yminus_faceMaterial = "solarCell";
% Zplus_faceMaterial = "solarCell";
% Zminus_faceMaterial = "solarCell";

% NAPA-1
Xplus_faceMaterial = "solarCell";
Xminus_faceMaterial = "solarCell";
Yplus_faceMaterial = "solarCell";
Yminus_faceMaterial = "blackCoating";
Zplus_faceMaterial = "solarCell";
Zminus_faceMaterial = "solarCell";

%Face orientation control (rotation from the default configuration - see plot)
attitude.orientationType = 'nadir';
attitude.rotationAboutZ = 0;
attitude.rotationAboutY = 0;
attitude.rotationAboutX = 90;

% Thermal conductivity between internal node with each external surface
payload2FacesConductivity = [1, 1, 1, 1, 1, 1]; % (W/K) Tips: 0-1: Low thermal conductivity, 1-4: Medium thermal conductivity, 4-8: High thermal conductivity

%% Ground Station (used to build Power Profile)

groundStationName = 'SJC';
MinElevationAngle = 10; % Minimum elevation angle over horizon (deg)
lat = -23.2198;
lon = -45.8916; 

%% Power Profile

opt.mode = 0;

switch opt.mode
    case 0 %NAOA-1
        disp('Mode 0: NAPA-1 Average')
        powerConsumption_at_daylight = 4; 
        powerConsumption_at_night = 4; 
        powerConsumption_at_groundStationAccess = 4; 
    case 1
        disp('Mode 1: Science Mode Hot Case')
        powerConsumption_at_daylight = 6.37; % EPS:0.3 + CubeComp: 0.2 + PLDH:0.3 + CTECS:1.3 + C&DH:0.3 + Nanomind:0.9 + TRCVU_iddle:0.42 + DSU_X:0.3 + Microzed:1.4 + Wheels:0.15 + PCDU:0.4 + Battery:0.4
        powerConsumption_at_night = 6.37; % Same as day operation
        powerConsumption_at_groundStationAccess = 6.37 + 11 + 3.33; % turned on X-Band TX:11, TRXVU: 3.33 (over iddle)
    case 2 
        disp('Mode 2: Science Mode Cold Case')
        powerConsumption_at_daylight = 6.37; % EPS:0.3 + CubeComp: 0.2 + PLDH:0.3 + CTECS:1.3 + C&DH:0.3 + Nanomind:0.9 + TRCVU_iddle:0.42 + DSU_X:0.3 + Microzed:1.4 + Wheels:0.15 + PCDU:0.4 + Battery:0.4
        powerConsumption_at_night = 6.37; % Same as day operation
        powerConsumption_at_groundStationAccess = 6.37; % No transmission
    case 3
        disp('Mode 3: SAFE Mode Hot Case')
        powerConsumption_at_daylight = 2.72; % EPS:0.3 + CubeComp: 0 + PLDH:0 + CTECS:0 + C&DH:0.3 + Nanomind:0.9 + TRCVU_iddle:0.42 + DSU_X:0 + Microzed:0 + Wheels:0 + PCDU:0.4 + Battery:0.4
        powerConsumption_at_night = 2.72; % Same as day operation
        powerConsumption_at_groundStationAccess = 2.72 + 3.33; % turned on X-Band TX:11, TRXVU: 3.33 (over iddle)
    case 4 
        disp('Mode 4: SAFE Mode Cold Case')
        powerConsumption_at_daylight = 2.72; % EPS:0.3 + CubeComp: 0 + PLDH:0 + CTECS:0 + C&DH:0.3 + Nanomind:0.9 + TRCVU_iddle:0.42 + DSU_X:0 + Microzed:0 + Wheels:0 + PCDU:0.4 + Battery:0.4
        powerConsumption_at_night = 2.72; % Same as day operation
        powerConsumption_at_groundStationAccess = 2.72; % No transmission
end

%%% Temperature dependent internal power (ex: Bang-bang control)
hasTemperatureRelatedPower = 0; % boolean
tempInterval = [0,6]; % (ºC) temperature interval to consider the aditional power for the internal node
aditionalPower = 1.2; % (W) battery heaters

%% 3 - ORBITAL PARAMETERS

centralBody = "earth"; % options: "earth", "moon"
startTime = datetime(2020,06,01,"TimeZone","UTC"); %datetime(2025,03,14,"TimeZone","UTC");
stopTime = startTime + days(1);
sampleTime = 60; % (s)
orbitPropagator = "sgp4"; % options: "two-body-keplerian", "sgp4", "sdp4"

% Classical elements at start time
semiMajorAxis = 6778.137e3; % m
eccentricity = 0;
inclination = 52.118; % deg
rightAscensionOfAscendingNode = 96.355; % deg
argumentOfPeriapsis = 0; % deg
trueAnomaly = 108.192; % deg

% NAPA-1
% semiMajorAxis = 6910.375681e3; % m
% eccentricity = 0.001356;
% inclination = 97.415; % deg
% rightAscensionOfAscendingNode = 246.897; % deg
% argumentOfPeriapsis = 65.897; % deg
% trueAnomaly = 152.853; % deg

%% 4 - Solar Panels

solarCellEff = .28; % Solar Cell Efficiency
effectiveAreaRatio = 0.75; % How much of the face area is effective covered by solar cells 

%% 5 - Animation
opt.showOrbitalAnimation = 0;% boolean

%% Save Inputs in Input folder

filePath = strcat('Input/',simulationName,'_mode',num2str(opt.mode),'_in','.mat');
disp(strcat('Inputs saved in ~/', filePath));
save(filePath)


