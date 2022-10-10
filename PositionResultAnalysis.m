% positioningResult: n*3 [valid, 2D_error, is_in_ellipse]  error前3列→error1
%   valid: 0 for invalid, 1 for valid
%   is_in_ellipse: 0 for not in, 1 for in

% percentage: m*1 contains the wanted error percentage, e.g. 67 for 67% 95
% result: m*2 [percentage 2D_err]
% hit = positioningResult(:,3); If estimation is in ellipse

% chu: [result successrate hitrate error]= PositionResultAnalysis(error1, percentage)
% chu: [result successrate hitrate error]= PositionResultAnalysis(error2, percentage)
function [result successrate hitrate error]= PositionResultAnalysis(positioningResult, percentage)
% Remove invalid position result
validIndex=(positioningResult(:,1)==1) & (~isnan(positioningResult(:,2)));
if sum(validIndex)==0
    result=nan;
    successrate=nan;
    hitrate=nan;
    return
end

successrate=sum(validIndex)/size(positioningResult,1);
positioningResult=positioningResult(validIndex,:);
% Hitrate
hit = positioningResult(:,3);
hitrate = sum(hit)/length(hit);
% 2D error of specified percentage
error = positioningResult(:,2);
error = sort(error);
result(:,1)=percentage;
result(:,2)=error(ceil(percentage/100*length(error)));

% e67 = error(ceil(0.67*length(error)));
% e95 = error(ceil(0.95*length(error)));
% e30 = error(ceil(0.3*length(error)));
% e60 = error(ceil(0.6*length(error)));
% % 50m
% tt=find(error>50,1,'first');
% e50m=tt/length(error)*100;
% % 100m
% tt=find(error>100,1,'first');
% e100m=tt/length(error)*100;
% % 300m
% tt=find(error>300,1,'first');
% if ~isempty(tt)
%     e300m=tt/length(error)*100;
% else
%     e300m=-1;
% end
%
% % 500m
% tt=find(error>500,1,'first');
% if ~isempty(tt)
%     e500m=tt/length(error)*100;
% else
%     e500m=-1;
% end
%

% Plot

n=0:length(error);
f=n/length(error)*100;

%remove by peter
% figure;
% hold on;
% plot([0;error],f,'g','LineWidth',2);
% title('CDF');
% xlabel('2D error (meter)');
% ylabel('percentage (%)');
% grid on
% 
% %set(h, 'Interpreter', 'None');
% % Plot accuracy indications in the figure
% % %%%%%%%%%Right%%%%%%%%%%%%
% % for i=1:length(percentage)
% %     text(result(i,2),result(i,1),[num2str(result(i,1)) '%:' num2str(round(result(i,2))) ' m' '\rightarrow'],...
% %         'HorizontalAlignment','right');
% % end
% 
% % %%%%%%%%%Left%%%%%%%%%%%%
% for i=1:length(percentage)
%     text(result(i,2),result(i,1),['\leftarrow' num2str(result(i,1)) '%:' num2str(round(result(i,2))) ' m'],...
%         'HorizontalAlignment','left');
% end

% %%%%%%%%%Right%%%%%%%%%%%%
% text(e67,67,['67%: ' num2str(round(e67)) ' m' '\rightarrow'],...
%     'HorizontalAlignment','right');
% text(e95,95,['95%: ' num2str(round(e95)) ' m' '\rightarrow'],...
%     'HorizontalAlignment','right');
% % text(50,e50m,['50m: ' num2str(round(e50m)) '%' '\rightarrow'],...
% %     'HorizontalAlignment','right');
% text(100,e100m,['100m: ' num2str(round(e100m)) '%' '\rightarrow'],...
%     'HorizontalAlignment','right');
%  if e300m~=-1 && e300m < 95
%       text(300,e300m,['300m: ' num2str(round(e300m)) '%' '\rightarrow'],...
%      'HorizontalAlignment','right');
%  end
%
%  if e500m~=-1 && e500m < 95
%       text(500,e500m,['500m: ' num2str(round(e500m)) '%' '\rightarrow'],...
%      'HorizontalAlignment','right');
%  end

%%%%%%%%%%%%%%Left%%%%%%%%%%%%%%%%%%%%
% text(e67,67,[ '\leftarrow' '67%: ' num2str(round(e67)) ' m'],...
%      'HorizontalAlignment','left');
% text(e95,95,[ '\leftarrow' '95%: ' num2str(round(e95)) ' m'],...
%      'HorizontalAlignment','left');
% % text(50,e50m,['\leftarrow 50m: ' num2str(round(e50m)) '%'],...
% %      'HorizontalAlignment','left');
% text(100,e100m,['\leftarrow 100m: ' num2str(round(e100m)) '%'],...
%      'HorizontalAlignment','left');
%
%
%  if e300m~=-1 && e300m < 95
%       text(300,e300m,['\leftarrow 300m: ' num2str(round(e300m)) '%'],...
%      'HorizontalAlignment','left');
%  end
%
%  if e500m~=-1 && e500m < 95
%       text(500,e500m,['\leftarrow 500m: ' num2str(round(e500m)) '%'],...
%      'HorizontalAlignment','left');
%  end