clear all
clc
% close all

lastPortion = .4;
num = 3; % Number of cases for each subplot
plotOrbits = ["hot","cold"];


titles = ["Internal node: [0.3, 0.3, 0.3, 0.3, 0.3, 0.3] (W/K)", ...
          "Internal node: [1, 1, 0.05, 0.05, 0.05, 0.05] (W/K)",...
          "Internal node: [0.05, 0.05, 0.05, 0.05, 0.05, 0.05] (W/K)"];

% HOT ORBIT - MODE 4
% hotOrbit1 = ["SPORT-1_Cond_1A_orb_hot_mode4_out.mat","SPORT-1_Cond_1B_orb_hot_mode4_out.mat", "SPORT-1_Cond_1C_orb_hot_mode4_out.mat"];
% hotOrbit2 = ["SPORT-1_Cond_2A_orb_hot_mode4_out.mat","SPORT-1_Cond_2B_orb_hot_mode4_out.mat", "SPORT-1_Cond_2C_orb_hot_mode4_out.mat"];
% hotOrbit3 = ["SPORT-1_Cond_3A_orb_hot_mode4_out.mat","SPORT-1_Cond_3B_orb_hot_mode4_out.mat", "SPORT-1_Cond_3C_orb_hot_mode4_out.mat"];
% hotOrbitFiles = [hotOrbit1;hotOrbit2;hotOrbit3];
% 
% % COLD ORBIT - MODE 4
% coldOrbit1 = ["SPORT-1_Cond_1A_orb_cold_mode4_out.mat","SPORT-1_Cond_1B_orb_cold_mode4_out.mat", "SPORT-1_Cond_1C_orb_cold_mode4_out.mat"];
% coldOrbit2 = ["SPORT-1_Cond_2A_orb_cold_mode4_out.mat","SPORT-1_Cond_2B_orb_cold_mode4_out.mat", "SPORT-1_Cond_2C_orb_cold_mode4_out.mat"];
% coldOrbit3 = ["SPORT-1_Cond_3A_orb_cold_mode4_out.mat","SPORT-1_Cond_3B_orb_cold_mode4_out.mat", "SPORT-1_Cond_3C_orb_cold_mode4_out.mat"];
% coldOrbitFiles = [coldOrbit1;coldOrbit2;coldOrbit3];

% % HOT ORBIT - MODE 1
% hotOrbit1 = ["SPORT-1_Cond_1A_orb_hot_mode1_out.mat","SPORT-1_Cond_1B_orb_hot_mode1_out.mat", "SPORT-1_Cond_1C_orb_hot_mode1_out.mat"];
% hotOrbit2 = ["SPORT-1_Cond_2A_orb_hot_mode1_out.mat","SPORT-1_Cond_2B_orb_hot_mode1_out.mat", "SPORT-1_Cond_2C_orb_hot_mode1_out.mat"];
% hotOrbit3 = ["SPORT-1_Cond_3A_orb_hot_mode1_out.mat","SPORT-1_Cond_3B_orb_hot_mode1_out.mat", "SPORT-1_Cond_3C_orb_hot_mode1_out.mat"];
% hotOrbitFiles = [hotOrbit1;hotOrbit2;hotOrbit3];
% 
% % COLD ORBIT - MODE 1
% coldOrbit1 = ["SPORT-1_Cond_1A_orb_cold_mode1_out.mat","SPORT-1_Cond_1B_orb_cold_mode1_out.mat", "SPORT-1_Cond_1C_orb_cold_mode1_out.mat"];
% coldOrbit2 = ["SPORT-1_Cond_2A_orb_cold_mode1_out.mat","SPORT-1_Cond_2B_orb_cold_mode1_out.mat", "SPORT-1_Cond_2C_orb_cold_mode1_out.mat"];
% coldOrbit3 = ["SPORT-1_Cond_3A_orb_cold_mode1_out.mat","SPORT-1_Cond_3B_orb_cold_mode1_out.mat", "SPORT-1_Cond_3C_orb_cold_mode1_out.mat"];
% coldOrbitFiles = [coldOrbit1;coldOrbit2;coldOrbit3];

figure ()

for k=1:length(titles)
    subplot(length(titles),1,k)
    x = [0, num+1]; 
    for n=1:num
        for j=1:length(plotOrbits)
            orbit = plotOrbits(j);
            if(orbit=="hot")
                load(strcat('Output/', hotOrbitFiles(k,n)));
            else
                load(strcat('Output/', coldOrbitFiles(k,n)));
            end
            len = length(seconds(T.time));
            startIndex = floor((1-lastPortion)*len);
            time = seconds(T.time);
            time = time(startIndex:end);

            Text = table2array(timetable2table(T(startIndex:end,1:6),'ConvertRowTimes',false));
            maxExternal = max(max(Text))-273.15;
            minExternal = min(min(Text))-273.15;
            Tint = table2array(timetable2table(T(startIndex:end,7),'ConvertRowTimes',false));
            maxInternal = max(max(Tint))-273.15;
            minInternal = min(min(Tint))-273.15;

            plotrange(n+(orbit=="cold")*.05,minExternal,maxExternal,minInternal,maxInternal,orbit);
            hold on
        end
    end
    xlim(x)
    xticks([1 2 3])
    xticklabels({'Ext Cond = 1%','Ext Cond = 5%','Ext Cond = 10%'})
    grid on
    title(titles(k))
end


% ylabel('Temp (K)')
% title('Internal node: [0.3, 0.3, 0.3, 0.3, 0.3, 0.3] (W/K)')


% subplot(3,1,2)
% num=length(outFiles2);
% data = zeros(num,4);
% for n=1:num
%     load(strcat('Output/', outFiles2(n)));
%     len = length(seconds(T.time));
%     startIndex = floor((1-lastPortion)*len);
%     time = seconds(T.time);
%     time = time(startIndex:end);
% 
%     Text = table2array(timetable2table(T(startIndex:end,1:6),'ConvertRowTimes',false));
%     maxExternal = max(max(Text));
%     minExternal = min(min(Text));
%     Tint = table2array(timetable2table(T(startIndex:end,7),'ConvertRowTimes',false));
%     maxInternal = max(max(Tint));
%     minInternal = min(min(Tint));
%     
%     data(n,1) = maxInternal; % Open
%     data(n,2) = maxExternal; % High
%     data(n,3) = minExternal; % Low
%     data(n,4) = minInternal; % Close
% end
% candle(data,'r');
% hold on
% plot(x,y,'-','color','k','linewidth',2)
% plot(x,y+25,'--','color','k','linewidth',2)
% plot(x,y-25,'--','color','k','linewidth',2)
% hold on
% xticks([1 2 3])
% xticklabels({'Ext Cond = 1%','Ext Cond = 5%','Ext Cond = 10%'})
% ylabel('Temp (K)')
% title('Internal node: [1, 1, .05, .05, .05, .05] (W/K)')
% 
% subplot(3,1,3)
% num=length(outFiles3);
% data = zeros(num,4);
% for n=1:num
%     load(strcat('Output/', outFiles3(n)));
%     len = length(seconds(T.time));
%     startIndex = floor((1-lastPortion)*len);
%     time = seconds(T.time);
%     time = time(startIndex:end);
% 
%     Text = table2array(timetable2table(T(startIndex:end,1:6),'ConvertRowTimes',false));
%     maxExternal = max(max(Text));
%     minExternal = min(min(Text));
%     Tint = table2array(timetable2table(T(startIndex:end,7),'ConvertRowTimes',false));
%     maxInternal = max(max(Tint));
%     minInternal = min(min(Tint));
%     
%     data(n,1) = maxInternal; % Open
%     data(n,2) = maxExternal; % High
%     data(n,3) = minExternal; % Low
%     data(n,4) = minInternal; % Close
% end
% candle(data,'r');
% hold on
% plot(x,y,'-','color','k','linewidth',2)
% plot(x,y+25,'--','color','k','linewidth',2)
% plot(x,y-25,'--','color','k','linewidth',2)
% hold on
% xticks([1 2 3])
% xticklabels({'Ext Cond = 1%','Ext Cond = 5%','Ext Cond = 10%'})
% ylabel('Temp (K)')
% title('Internal node: [0.05, 0.05, .05, .05, .05, .05] (W/K)')
% 



% grid on
% legend('',"1%","5%","10%","")
% set(gca,'FontSize',16)