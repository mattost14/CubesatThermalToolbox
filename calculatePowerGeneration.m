function P = calculatePowerGeneration(solarLightIntensity, param)
    P = 0;
    for i=1:6
        if(param.facesMaterial(i)=="solarCell")
            P=P+solarLightIntensity.(i)*param.solarFlux*param.area(i)*param.solarCellEff*param.effectiveAreaRatio;
        end
    end
end