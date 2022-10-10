figure
tempcolor = hot(12+2);
for j = 1:12
  for i=1:100
    similarity1st(j,i) = SimilarMeasurementsbest{i,1}(j,19);  

  end
  hold on
  plot(similarity1st(j,:),'color',tempcolor(j,:),'LineWidth',2);
  
end



% 
% figure
% for i=1:2:25
%     hold on
%     plot(errorlist{i,1}(:,2),'color',tempcolor(i,:));
%     
% 
% end
% legend('1','3','5','7','9','11','13','15','17','19','21','23','25');  
