function plotCubesat(param)
    facesPoints = getCubeSatPlotPoints(param.numberOfUnits);
    X = [1 0 0];
    Y = [0 1 0];
    Z = [0 0 1];
    scale = 2.9;
    for i=1:length(param.facesMaterial)
        h = surf(facesPoints(i).x, facesPoints(i).y, facesPoints(i).z, 'CData',getTexture(param.facesMaterial(i)), 'FaceColor','texturemap', 'edgecolor','#656565', 'LineWidth', 3); 
        rotate(h, Z, param.attitude.rotationAboutZ, [0,0,0]) %rotation about Z
        rotate(h, angle2dcm(deg2rad(param.attitude.rotationAboutZ), 0, 0,'ZYX')'*Y', param.attitude.rotationAboutY, [0,0,0]) %rotation about Y
        rotate(h, angle2dcm(deg2rad(param.attitude.rotationAboutZ), deg2rad(param.attitude.rotationAboutY), 0,'ZYX')'*X', param.attitude.rotationAboutX, [0,0,0]) %rotation about X
        hold on;
    end
    
    plot3([-5,5],[0,0],[0,0],'LineWidth',2, 'Color', '#f2b009')
    
    h = surf([-3, 3; -3, 3],[-3, -3; 3, 3], [-3, -3; -3, -3], 'CData',getTexture(param.centralBody), 'FaceColor','texturemap', 'edgecolor','#656565', 'LineWidth', 3);

    axis([ -1  1  -1  1 -1  1]*3)
%     xlabel('Y - ZcrossX')
%     ylabel('Z - Orbital Normal')
%     zlabel('X - Orbital Radial')
    grid on
    axis vis3d
    
    Xbody = angle2dcm(deg2rad(param.attitude.rotationAboutZ), deg2rad(param.attitude.rotationAboutY), deg2rad(param.attitude.rotationAboutX),'ZYX')'*X'*scale;
    Ybody = angle2dcm(deg2rad(param.attitude.rotationAboutZ), deg2rad(param.attitude.rotationAboutY), deg2rad(param.attitude.rotationAboutX),'ZYX')'*Y'*scale;
    Zbody = angle2dcm(deg2rad(param.attitude.rotationAboutZ), deg2rad(param.attitude.rotationAboutY), deg2rad(param.attitude.rotationAboutX),'ZYX')'*Z'*scale;
      
    q=quiver3([0],[0],[0],Xbody(1),Xbody(2),Xbody(3), 'Color','g','LineWidth',5);
    text(Xbody(1),Xbody(2),Xbody(3),'X+','HorizontalAlignment','left','FontSize',28);
    
    q=quiver3([0],[0],[0],Ybody(1),Ybody(2),Ybody(3), 'Color','r','LineWidth',5);
    t=text(Ybody(1),Ybody(2),Ybody(3),'Y+','HorizontalAlignment','left','FontSize',28);

    q=quiver3([0],[0],[0],Zbody(1),Zbody(2),Zbody(3), 'Color','b','LineWidth',5);
    text(Zbody(1),Zbody(2),Zbody(3),'Z+','HorizontalAlignment','left','FontSize',28);
    
    set(gca, 'Xdir', 'reverse')
    set(gca, 'Ydir', 'reverse')
end