function P = getCubeSatPlotPoints(numberOfUnits)

    switch numberOfUnits
        case 1
            numberUnitAlongX = 1;
            numberUnitAlongY = 1;
            numberUnitAlongZ = 1;
        case 3
            numberUnitAlongX = 3;
            numberUnitAlongY = 1;
            numberUnitAlongZ = 1;
        case 6
            numberUnitAlongX = 3;
            numberUnitAlongY = 2;
            numberUnitAlongZ = 1;
        case 12
            numberUnitAlongX = 3;
            numberUnitAlongY = 2;
            numberUnitAlongZ = 2;
    end
    
        % X face
%         x_faceX = ones(numberUnitAlongZ+1, numberUnitAlongY+1)*(numberUnitAlongX)*.5;
%         y_faceX = [ .5, -.5; .5, -.5];
%         z_faceX = [ones(1,length(y_faceX)); -ones(1,length(y_faceX))]*(.5);
%         faceX_plus.x = x_faceX;
%         faceX_plus.y = y_faceX;
%         faceX_plus.z = z_faceX;
%         faceX_minus = faceX_plus;
%         faceX_minus.x = -faceX_minus.x;

    switch numberOfUnits
        case 1
            % X face
            x_faceX = [ 0.5, 0.5, ; 0.5, 0.5];
            y_faceX = [ .5, -.5; .5, -.5];
            z_faceX = [ones(1,length(y_faceX)); -ones(1,length(y_faceX))]*(.5);
            faceX_plus.x = x_faceX;
            faceX_plus.y = y_faceX;
            faceX_plus.z = z_faceX;
            faceX_minus = faceX_plus;
            faceX_minus.x = -faceX_minus.x;
            % Y face
            x_faceY = [ .5, -.5; .5, -.5];
            y_faceY = [ 1, 1; 1,1]*.5;
            z_faceY = [ones(1,length(y_faceY)); -ones(1,length(y_faceY))]*(.5);
            faceY_plus.x = x_faceY;
            faceY_plus.y = y_faceY;
            faceY_plus.z = z_faceY;
            faceY_minus = faceY_plus;
            faceY_minus.y = -faceY_minus.y;
            % Z face
            x_faceZ = [ -.5, .5; -.5, .5];
            y_faceZ = [-1, -1; 1,1]*.5;
            z_faceZ = [ones(1,length(y_faceZ)); ones(1,length(y_faceZ)); ]*(.5);
            faceZ_plus.x = x_faceZ;
            faceZ_plus.y = y_faceZ;
            faceZ_plus.z = z_faceZ;
            faceZ_minus = faceZ_plus;
            faceZ_minus.z = -faceZ_minus.z;
            P = [faceX_plus, faceX_minus, faceY_plus, faceY_minus, faceZ_plus, faceZ_minus];
        case 3
            % X face
            x_faceX = [ 1.5, 1.5, ; 1.5, 1.5];
            y_faceX = [ .5, -.5; .5, -.5];
            z_faceX = [ones(1,length(y_faceX)); -ones(1,length(y_faceX))]*(.5);
            faceX_plus.x = x_faceX;
            faceX_plus.y = y_faceX;
            faceX_plus.z = z_faceX;
            faceX_minus = faceX_plus;
            faceX_minus.x = -faceX_minus.x;
            % Y face
            x_faceY = [ -1.5, -.5, .5, 1.5; -1.5, -.5, .5, 1.5;];
            y_faceY = [ 1, 1, 1, 1; 1,1,1,1]*.5;
            z_faceY = [ones(1,length(y_faceY)); -ones(1,length(y_faceY))]*(.5);
            faceY_plus.x = x_faceY;
            faceY_plus.y = y_faceY;
            faceY_plus.z = z_faceY;
            faceY_minus = faceY_plus;
            faceY_minus.y = -faceY_minus.y;
            % Z face
            x_faceZ = [ -1.5, -.5, .5, 1.5;  -1.5, -.5, .5, 1.5];
            y_faceZ = [ -.5, -.5, -.5, -.5;  .5, .5, .5, .5;];
            z_faceZ = [ones(1,length(y_faceZ)); ones(1,length(y_faceZ)); ]*(.5);
            faceZ_plus.x = x_faceZ;
            faceZ_plus.y = y_faceZ;
            faceZ_plus.z = z_faceZ;
            faceZ_minus = faceZ_plus;
            faceZ_minus.z = -faceZ_minus.z;
            P = [faceX_plus, faceX_minus, faceY_plus, faceY_minus, faceZ_plus, faceZ_minus];
        case 6
            % X face
            x_faceX = [ 1.5, 1.5, 1.5; 1.5, 1.5, 1.5];
            y_faceX = [ -1, 0, 1; -1, 0, 1];
            z_faceX = [ones(1,length(y_faceX)); -ones(1,length(y_faceX))]*(.5);
            faceX_plus.x = x_faceX;
            faceX_plus.y = y_faceX;
            faceX_plus.z = z_faceX;
            faceX_minus = faceX_plus;
            faceX_minus.x = -faceX_minus.x;
            % Y face
            x_faceY = [ -1.5, -.5, .5, 1.5;-1.5, -.5, .5, 1.5;];
            y_faceY = [ 1, 1, 1, 1; 1,1,1,1];
            z_faceY = [ones(1,length(y_faceY)); -ones(1,length(y_faceY))]*(.5);
            faceY_plus.x = x_faceY;
            faceY_plus.y = y_faceY;
            faceY_plus.z = z_faceY;
            faceY_minus = faceY_plus;
            faceY_minus.y = -faceY_minus.y;
            % Z face
            x_faceZ = [ -1.5, -.5, .5, 1.5; -1.5, -.5, .5, 1.5; -1.5, -.5, .5, 1.5;];
            y_faceZ = [ -1, -1, -1, -1; 0, 0, 0, 0; 1, 1, 1, 1];
            z_faceZ = [ones(1,length(y_faceZ)); ones(1,length(y_faceZ)); ones(1,length(y_faceZ)) ]*(.5);
            faceZ_plus.x = x_faceZ;
            faceZ_plus.y = y_faceZ;
            faceZ_plus.z = z_faceZ;
            faceZ_minus = faceZ_plus;
            faceZ_minus.z = -faceZ_minus.z;
            P = [faceX_plus, faceX_minus, faceY_plus, faceY_minus, faceZ_plus, faceZ_minus];
        case 12
            % X face
            x_faceX = ones(numberUnitAlongZ+1, numberUnitAlongY+1)*(numberUnitAlongX)*.5;
            y_faceX = [ -1, 0, 1; -1, 0, 1; -1, 0, 1];
            z_faceX = [ones(1,length(y_faceX)); 0, 0, 0; -ones(1,length(y_faceX))];
            faceX_plus.x = x_faceX;
            faceX_plus.y = y_faceX;
            faceX_plus.z = z_faceX;
            faceX_minus = faceX_plus;
            faceX_minus.x = -faceX_minus.x;
            % Y face
            x_faceY = [ -1.5, -.5, .5, 1.5; -1.5, -.5, .5, 1.5; -1.5, -.5, .5, 1.5];
            y_faceY = [ 1, 1, 1, 1; 1,1,1,1 ; 1,1,1,1];
            z_faceY = [ones(1,length(y_faceY)); 0, 0, 0, 0; -ones(1,length(y_faceY))];
            faceY_plus.x = x_faceY;
            faceY_plus.y = y_faceY;
            faceY_plus.z = z_faceY;
            faceY_minus = faceY_plus;
            faceY_minus.y = -faceY_minus.y;
            % Z face
            x_faceZ = [ -1.5, -.5, .5, 1.5; -1.5, -.5, .5, 1.5; -1.5, -.5, .5, 1.5];
            y_faceZ = [ -1, -1, -1, -1; 0, 0, 0, 0; 1, 1, 1, 1];
            z_faceZ = [ones(1,length(y_faceZ)); ones(1,length(y_faceZ)); ones(1,length(y_faceZ)) ];
            faceZ_plus.x = x_faceZ;
            faceZ_plus.y = y_faceZ;
            faceZ_plus.z = z_faceZ;
            faceZ_minus = faceZ_plus;
            faceZ_minus.z = -faceZ_minus.z;
            P = [faceX_plus, faceX_minus, faceY_plus, faceY_minus, faceZ_plus, faceZ_minus];
    end
end