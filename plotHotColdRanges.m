clear all
clc
close all

lastPortion = .4;
num = 1; % Number of cases for each subplot
plotOrbits = ["hot","cold"];


titles = ["MODE 1: Science Mode Hot Case", ...
          "MODE 4: Safe Mode Cold Case"];

% HOT/COLD ORBIT FILES
hotOrbitFiles = ["SPORT-1_orb_hot_mode1_out.mat";"SPORT-1_orb_hot_mode4_out.mat"];
coldOrbitFiles = ["SPORT-1_orb_cold_mode1_out.mat";"SPORT-1_orb_cold_mode4_out.mat"];

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

            plotrange(n+(orbit=="cold")*1,minExternal,maxExternal,minInternal,maxInternal,orbit);
            hold on
        end
    end
    xlim([0, 3])
    ylim([-40,80])
    xticks([1 2 3])
    ylabel('Temperature (ºC)')
    xticklabels({'Hot orbit','Cold orbit'})
    grid on
    set(gca,'FontSize',14)
    title(titles(k))
    legend
end



