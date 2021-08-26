function p = getCentralBodyProperties(body)
    switch body
        case 'earth'
            p.Tir_Day = 254;% default: 254; % Black-body temp during day time (K)
            p.Tir_Night = 254;%default: 254; % Black-body temp during night time (K)
            p.radius = 6371; % Radius (km)
            p.albedoFactor = 0.3; % Albedo
            p.albedoFactorByLatitudeTable = 'EarthAlbedoByLatitude.mat'; % If this field exists, then the albedoFactor will be calculate from table instead of using the albedoFactor average value
            p.solarFlux = 1367; % Solar flux (W/m2)
            p.GM = 3.986004418e14; % Standard gravitational parameter (m3s−2)
        case 'moon'
            p.Tir_Day = 380; 
            p.Tir_Night = 130;
%             p.Tir_Day = 270.4; 
%             p.Tir_Night = 270.4; 
            p.radius = 1737.4; 
            p.albedoFactor = 0.12;
            p.solarFlux = 1367; % 
        case 'mars'
            p.Tir_Day = 209.8; 
            p.Tir_Night = 209.8;
            p.radius = 3389.5; 
            p.albedoFactor = 0.15;
            p.solarFlux = 590; 
    end
end