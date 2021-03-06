function p = getPropertiesFromMaterial(material)
    switch material
        case 'solarCell'
            p.Cp = 1164; % Specific heat (J/(kg*K)) FR4: 1164 J/(kg*K)
            p.rho = 1809; % Density (kg/m3)
            p.absorp = 0.95; % Absorptivity Solar
            p.emiss = 0.95; % Emissivity Solar
        case 'blackCoating'
            p.Cp = 960; % Specific heat (J/(kg*K))
            p.rho = 2765; % Density (kg/m3)
            p.absorp = 0.96; % Absorptivity Solar
            p.emiss = 0.91; % Emissivity Solar
        case 'whiteCoating'
            p.Cp = 960; % Specific heat (J/(kg*K))
            p.rho = 2765; % Density (kg/m3)
            p.absorp = 0.2; % Absorptivity Solar
            p.emiss = 0.92; % Emissivity Solar
        case 'goldCoating'
            p.Cp = 960; % Specific heat (J/(kg*K))
            p.rho = 2765; % Density (kg/m3)
            p.absorp = 0.19; % Absorptivity Solar
            p.emiss = 0.025; % Emissivity Solar 
    end
end