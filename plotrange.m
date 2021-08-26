function plotrange(x,extMin,extMax,intMin,intMax,orbit)
    if(orbit=="hot")
        colors=["#ff9900","#ff0000"];
    else
        colors=["#30b09e",'b'];
    end
    %External Temp range
    e=errorbar(x,mean([extMin,extMax]),mean([extMin,extMax])-extMin,mean([extMin,extMax])-extMax,'CapSize',0,'DisplayName','External range');
    e.Color=colors(1);
    e.LineWidth = 2;
    e.LineStyle = 'none';
    hold on
    %Internal Temp range
    e=errorbar(x,mean([intMin,intMax]),mean([intMin,intMax])-intMin,mean([intMin,intMax])-intMax,'CapSize',0,'DisplayName','Internal range');
    e.Color=colors(2);
    e.LineWidth = 15;
    e.LineStyle = 'none';
end