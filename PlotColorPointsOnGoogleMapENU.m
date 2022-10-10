%points: [lat long] in degree
%refPoint: [lat long] in degree
%Range: [leftLong rightLong bottomLat topLat]
%error: [isSuccess 2d_error isInEllipse confidence]
%colorMap
function PlotColorPointsOnGoogleMapENU(map,originRange, points, refPoint, power, colorMap, power_step)
range=0.0001;
ERROR_MAX=99999;

%targetRange=[min(points(:,1))-range max(points(:,1))+range min(points(:,2))-range max(points(:,2))+range];
targetRange=originRange;

%figure
if ~isempty(map)
    ShowGoogleMapENU(map,originRange,targetRange,refPoint);
else
    figure;
end
hold on
pointsET=convertlatlong2enu(points*pi/180, refPoint*pi/180);
cmap=colormap(colorMap); % 64*3
numOfColor=size(cmap,1);
power_list=min(power):power_step:(max(power)+power_step);
power_label=cell(1,length(power_list));

for i=1:length(power_list)-1
    power_start=power_list(i);
    power_stop=power_list(i+1);
    small_step=(power_stop-power_start)/8;
    for j=0:7
        tt=power>=(power_start+small_step*j) &...
            power<(power_start+small_step*(j+1));
        if ~isempty(tt)
            plot(pointsET(tt,1),pointsET(tt,2),'.','Color',cmap(((i-1)*8+j+1),:));
        end
    end
    power_label{1,i}=num2str(power_start);
end
power_label{1,length(power_list)+1}='Similarity';
%plot(pointsET(:,1),pointsET(:,2),style);
%plot(pointsET(:,1),pointsET(:,2),'p','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',6);
xlabel('EAST (meter)');
ylabel('NORTH (meter)');
caxis([min(power) (max(power)+power_step)]); %Color axis scaling

YTICK=power_list;
colorbar('location','EastOutside','ytick',YTICK,'YTickLabel',power_label);
