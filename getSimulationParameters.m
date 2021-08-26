
function [param, opt] = getSimulationParameters()
%% Load user inputs
run('inputs.m')

%% Generate parameters

chassis2TotalMassRatio = .2; % How much of the total mass goes for the satellite chassis (default: 25%)

param.Tinf = 4; % Cold Space Temp (K)
sigma = 5.67e-8; % Stefan-Boltzmann constant (W · m -2 · K -4 )
unitArea = 0.1*0.1; % Unit area (m2)
plateThickness = .003; % (m)
cornerJointLength = 0.005; % (m)
K_Al7075_t7351 = 155; % (W/(m*K)) - Thermal conductivity of Aluminum 7075-t7351 used in cubesat frames
theta_EarthBlockingSunFromMoon = atan2(6371,382500)*180/pi; % (deg) angular distance that Earth starts blocking the Sun from Moon

chassisMass = chassis2TotalMassRatio*satelliteMass;
payloadMass = (1-chassis2TotalMassRatio)*satelliteMass;


switch numberOfUnits
    case 1
        facesMassDistribution = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6]; %[X+,X-,Y+,Y-,Z+, Z-]
        facesArea = facesMassDistribution*(6*unitArea);
        XYUnitsSection = 1;
        XZUnitsSection = 1;
        YZUnitsSection = 1;
    case 3
        facesMassDistribution = [3/14, 3/14, 3/14, 3/14, 1/14, 1/14]; 
        facesArea = facesMassDistribution*(14*unitArea);
        XYUnitsSection = 1;
        XZUnitsSection = 1;
        YZUnitsSection = 3;
    case 6
        facesMassDistribution = [2/22, 2/22, 3/22, 3/22, 6/22, 6/22]; %[6/22, 6/22, 3/22, 3/22, 2/22, 2/22]
        facesArea = facesMassDistribution*(22*unitArea);
        XYUnitsSection = 1;
        XZUnitsSection = 2;
        YZUnitsSection = 3;
    case 12
        facesMassDistribution = [6/32, 6/32, 6/32, 6/32, 4/32, 4/32];
        facesArea = facesMassDistribution*(32*unitArea);
        XYUnitsSection = 2;
        XZUnitsSection = 2;
        YZUnitsSection = 3;
end

% Mass distribution
if(~exist('externalMassDistribution','var'))
    mass = [facesMassDistribution*chassisMass, payloadMass];
else
    mass = [externalMassDistribution, satelliteMass-sum(externalMassDistribution)];
end

% Faces cp
facesMaterial = [Xplus_faceMaterial, Xminus_faceMaterial, Yplus_faceMaterial, Yminus_faceMaterial, Zplus_faceMaterial, Zminus_faceMaterial];

faces_Cp = [getPropertiesFromMaterial(facesMaterial(1)).Cp,...
            getPropertiesFromMaterial(facesMaterial(2)).Cp,...
            getPropertiesFromMaterial(facesMaterial(3)).Cp,...
            getPropertiesFromMaterial(facesMaterial(4)).Cp,...
            getPropertiesFromMaterial(facesMaterial(5)).Cp,...
            getPropertiesFromMaterial(facesMaterial(6)).Cp]; 
emissivity = [getPropertiesFromMaterial(facesMaterial(1)).emiss,...
            getPropertiesFromMaterial(facesMaterial(2)).emiss,...
            getPropertiesFromMaterial(facesMaterial(3)).emiss,...
            getPropertiesFromMaterial(facesMaterial(4)).emiss,...
            getPropertiesFromMaterial(facesMaterial(5)).emiss,...
            getPropertiesFromMaterial(facesMaterial(6)).emiss]; 
param.absorptivity = [getPropertiesFromMaterial(facesMaterial(1)).absorp,...
            getPropertiesFromMaterial(facesMaterial(2)).absorp,...
            getPropertiesFromMaterial(facesMaterial(3)).absorp,...
            getPropertiesFromMaterial(facesMaterial(4)).absorp,...
            getPropertiesFromMaterial(facesMaterial(5)).absorp,...
            getPropertiesFromMaterial(facesMaterial(6)).absorp]; 

% Payload
payloadCp = 903; %J/(kg*K)


%% Interconnections

% Matrix of link between faces
FaceLinks = [%X+, %X-, %Y+, %Y-, %Z+, %Z-
             0, 0, 1, 1, 1, 1;... %X+
             0, 0, 1, 1, 1, 1;... %X-
             1, 1, 0, 0, 1, 1;... %Y+
             1, 1, 0, 0, 1, 1;... %Y-
             1, 1, 1, 1, 0, 0;... %Z+
             1, 1, 1, 1, 0, 0;... %Z+
             ];
         
% Matrix of Faces Thermal Conductivity
k = FaceLinks*K_Al7075_t7351;

% Matrix of Faces Link Area (dependent on number of units)
       %X+, %X-, %Y+, %Y-, %Z+, %Z-
A(1,:) = [  0,   0, XYUnitsSection*.1*plateThickness, XYUnitsSection*.1*plateThickness, XZUnitsSection*.1*plateThickness, XZUnitsSection*.1*plateThickness]; 
A(2,:) = [  0,   0, XYUnitsSection*.1*plateThickness, XYUnitsSection*.1*plateThickness, XZUnitsSection*.1*plateThickness, XZUnitsSection*.1*plateThickness];
A(3,:) = [XYUnitsSection*.1*plateThickness, XYUnitsSection*.1*plateThickness,   0,   0, YZUnitsSection*.1*plateThickness, YZUnitsSection*.1*plateThickness];
A(4,:) = [XYUnitsSection*.1*plateThickness, XYUnitsSection*.1*plateThickness,   0,   0, YZUnitsSection*.1*plateThickness, YZUnitsSection*.1*plateThickness];
A(5,:) = [XZUnitsSection*.1*plateThickness, XZUnitsSection*.1*plateThickness, YZUnitsSection*.1*plateThickness, YZUnitsSection*.1*plateThickness,   0,   0];
A(6,:) = [XZUnitsSection*.1*plateThickness, XZUnitsSection*.1*plateThickness, YZUnitsSection*.1*plateThickness, YZUnitsSection*.1*plateThickness,   0,   0];


% Matrix of Faces link length
       %X+, %X-, %Y+, %Y-, %Z+, %Z-
L = FaceLinks*cornerJointLength;

Conductivity = (externalConductivityRelativeRatio*k.*A)./L;                           
Conductivity(7,:) = payload2FacesConductivity;
Conductivity(:,7) = [payload2FacesConductivity'; 0];

% Conductivity = [0, 0, 0, 0, 0, 0, 0;...
%                 0, 0, 0, 0, 0, 0, 0;...
%                 0, 0, 0, 0, 0, 0, 0;...
%                 0, 0, 0, 0, 0, 0, 1;...
%                 0, 0, 0, 0, 0, 0, 0;...
%                 0, 0, 0, 0, 0, 0, 0;...
%                 0, 0, 0, 1, 0, 0, 0];
            
disp('Conductivity Matrix:')
disp(Conductivity)

%% Get orbital data

sc = satelliteScenario(startTime,stopTime,sampleTime);
sat = satellite(sc, semiMajorAxis, eccentricity, inclination, ...
    rightAscensionOfAscendingNode, argumentOfPeriapsis, trueAnomaly,'Name', satName, "OrbitPropagator", orbitPropagator);
gs = groundStation(sc, lat, lon, 'MinElevationAngle', MinElevationAngle, 'Name', groundStationName);
groundStationAccess = access(sat, gs);
groundStationAccessIntvls = accessIntervals(groundStationAccess);
numberOfAccess = height(groundStationAccessIntvls);

orb = getOrbitalData (sc,sat,attitude,centralBody);

%% Power Consumption Profile

power = zeros(length(orb.solarLight.time),1);
for i=1:length(power)
    if(orb.solarLight.magnitude(i))
        power(i) = powerConsumption_at_daylight;
    else
        power(i) = powerConsumption_at_night;
    end
    % Check if it is during ground station access
    if(numberOfAccess>0)
        for n = 1:numberOfAccess
            if(isbetween(orb.orbitalData.time_UTC(i),groundStationAccessIntvls(n,:).StartTime, groundStationAccessIntvls(n,:).EndTime))
                power(i) = powerConsumption_at_groundStationAccess;
                break
            end
        end
    end
end
powerProfile(:,1) = seconds(orb.orbitalData.Time_EpSec_);
powerProfile(:,2) = power;
powerProfile = array2table(powerProfile);
powerProfile.Properties.VariableNames = {'time','internalPower'};
powerProfile.time = seconds(powerProfile.time); 
powerProfile = table2timetable(powerProfile);

%% Power Balance Checker
solarFlux = getCentralBodyProperties(centralBody).solarFlux;
electricalEfficiency = zeros(length(powerProfile.time),1);
energyDrawnFromBat_Wh = zeros(length(powerProfile.time),1);
energyDebtToChargeBat = 0;
for i=1:length(powerProfile.time)   
    if(orb.solarLight.magnitude(i)) % if sat is under sun light       
        % Calculated maximum power generated by the solar cells
        generatedPwr = 0;
        for n=1:6
            if(facesMaterial(n)=="solarCell")
                % Power from Direct solar 
                generatedPwr=generatedPwr+orb.solarLight(i,:).(n) * solarFlux * facesArea(n) * solarCellEff * effectiveAreaRatio;
                % Power from Albedo
                Fir = orb.viewFactor(i,:).(n);
                theta = orb.albedoAngle(i,:).AlbedoAngle_deg_;
                Falb = Fir*max(0, cosd(theta));
                if(size(orb.albedoFactor,1)>1)
                    albedoFactor = orb.albedoFactor(i);
                else
                    albedoFactor = orb.albedoFactor;
                end
                generatedPwr = generatedPwr+ Falb * solarFlux * facesArea(n) * albedoFactor * solarCellEff * effectiveAreaRatio;
            end
        end
        
        % Check power generation surplus (Generated Pwr - Consumed Pwr)
        powerLeftToChargeBat = generatedPwr - powerProfile.internalPower(i);
        
        % Check the need to charge battery
        if(energyDebtToChargeBat>0 || powerLeftToChargeBat<0) % Battery is not full or generatedPwr is not enought to sustain power consumption
            electricalEfficiency(i)=1;         
            energyToChargeBat = powerLeftToChargeBat*sampleTime;
            energyDebtToChargeBat=energyDebtToChargeBat-energyToChargeBat;
            if(energyDebtToChargeBat<=0) % Battery is full
                energyDebtToChargeBat=0;
            end
        else
            % battery is full, so electrical efficiency is driven by how
            % much power the sat is consuming
            electricalEfficiency(i)=powerProfile.internalPower(i)/generatedPwr;
        end
    else
        % Sat is under eclipse, so all power is drawn from battery
        energyDebtToChargeBat = energyDebtToChargeBat+ powerProfile.internalPower(i).*sampleTime;
    end
    energyDrawnFromBat_Wh(i) = energyDebtToChargeBat/(3600); %Ws->Wh
end
% if(energyDebtToChargeBat)
%     disp('WARNING: power consumption and power generation is not balanced.')
% end

%% Save simulation parameters as a struct
param.Conductivity = Conductivity;
param.emissivity = emissivity;
param.krad = [emissivity, 0]*sigma;
param.mass = mass; 
param.cp = [faces_Cp, payloadCp];
param.powerProfile = powerProfile;
param.area = [facesArea, 0];
param.solarFlux = solarFlux;
param.numberOfUnits = numberOfUnits;
param.facesMaterial = facesMaterial;
param.centralBody = centralBody;
param.facesMaterial = facesMaterial;
param.attitude = attitude;
param.orbitalData = orb.orbitalData;
param.simulationName = simulationName;
param.solarCellEff = solarCellEff;
param.effectiveAreaRatio = effectiveAreaRatio;
param.sat = sat;
param.sc = sc;
param.solarLight = orb.solarLight;
param.viewFactor = orb.viewFactor;
param.albedoAngle = orb.albedoAngle;
param.albedoFactor = orb.albedoFactor;
param.Pir = orb.Pir;
param.electricalEfficiency = electricalEfficiency;
param.energyDrawnFromBat_Wh = energyDrawnFromBat_Wh;
% Power dependent of Temp parameters
param.hasTemperatureRelatedPower = hasTemperatureRelatedPower;
param.tempInterval = tempInterval;
param.aditionalPower = aditionalPower;

end
% clearvars -except param opt