function dXdt = funODE45(t,X, param)
    numberOfNodes = length(param.mass);
    mCpdXdt = zeros(numberOfNodes,1);
    dXdt = zeros(numberOfNodes,1);
    for i=1:numberOfNodes % for all nodes
        % Conduction with other nodes
        for j=1:numberOfNodes
            if(~isnan(param.Conductivity(i,j)) && param.Conductivity(i,j))
                mCpdXdt(i) = mCpdXdt(i) + (X(j)-X(i))*param.Conductivity(i,j);
            end
        end
        
        % Internal Power
        if(i==7)
            power = interp1(seconds(param.powerProfile.time), param.powerProfile.internalPower, t, 'nearest');
            mCpdXdt(i) = mCpdXdt(i) + power;
            
            if(param.hasTemperatureRelatedPower && ( (X(7)-273.15) < param.tempInterval(2) && (X(7)-273.15) > param.tempInterval(1)))
                mCpdXdt(i) = mCpdXdt(i) + param.aditionalPower;
            end
        end
             
        % External Nodes radiation     
        if(i<7)
            % View factor
            Fir = interp1(seconds(param.viewFactor.time), param.viewFactor.(i), t, 'nearest');
            
            % Radiation out to cold space considering view factor: 1-Fir
            mCpdXdt(i) = mCpdXdt(i) + param.krad(i)*param.area(i)*(param.Tinf^4 - X(i)^4)*(1-Fir);
            
            % Central Body IR
            Pir = interp1(seconds(param.viewFactor.time),param.Pir, t, 'nearest');   
            mCpdXdt(i) = mCpdXdt(i) + Fir * Pir * param.emissivity(i) * param.area(i);
            
            % Solar flux (direct and albedo);
            solarIntensity = interp1(seconds(param.solarLight.time), param.solarLight.(i), t, 'nearest');
            
            if(solarIntensity)
                if(size(param.albedoFactor,1)>1)
                    albedoFactor = interp1(seconds(param.albedoAngle.time), param.albedoFactor, t, 'nearest');
                else
                    albedoFactor = param.albedoFactor;
                end
                theta = interp1(seconds(param.albedoAngle.time), param.albedoAngle.AlbedoAngle_deg_, t, 'nearest');
                Falb = Fir*max(0, cosd(theta));
                if(param.facesMaterial(i)=="solarCell") % If face is solar cell, check whether it is generating electrical energy or it is dissipating outside  
                    electricalEfficiency = interp1(seconds(param.solarLight.time), param.electricalEfficiency, t, 'nearest');
                    mCpdXdt(i) = mCpdXdt(i) + abs(solarIntensity) * param.solarFlux * param.area(i) * param.absorptivity(i) * (1-electricalEfficiency*param.solarCellEff); % Heat flux from direct solar light, discounting if it is generating electrical power
                    mCpdXdt(i) = mCpdXdt(i) + Falb * param.solarFlux * param.area(i) * albedoFactor *  param.absorptivity(i) * (1-electricalEfficiency*param.solarCellEff); % Heat flux from albedo, discounting if it is generating electrical power
                else
                    mCpdXdt(i) = mCpdXdt(i) + abs(solarIntensity) * param.solarFlux * param.area(i) * param.absorptivity(i); % Heat flux from firect solar light
                    mCpdXdt(i) = mCpdXdt(i) + Falb * param.solarFlux * param.area(i) * albedoFactor *  param.absorptivity(i); % Heat flux from albedo
                end                   
            end
        
        end
        
        % Dividing by the thermal m*Cp
        dXdt(i) = mCpdXdt(i)/(param.cp(i)*param.mass(i));
    end
end