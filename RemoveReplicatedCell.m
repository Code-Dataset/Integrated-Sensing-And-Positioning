function measurement=RemoveReplicatedCell(measurement, criteria)
ImportedDataFormat;
%从measurement里面取出主服务小区，邻区以及路损/小区信号强度的信息，形成一个结构如下的矩阵
%主要就是把主小区和邻区的cellid放在一列，把路损/小区信号强度的信息作为第二列
for i=1:size(measurement,1)
    cell=[measurement(i,[SC_COL NB_COL])' measurement(i,SS_COL)']; %三列的矩阵 SC SS 0
    cell(:,3)=0;                                                   %          NB SS 0
    
    tt=cell(:,1)==measurement(i,SC_COL); %然后将cellid中是主小区的那些行标记出来，第三列置为1
    cell(tt,3)=1; %serving cell weight
    
    if strcmp(criteria, 'pathloss')
        cell=sortrows(cell,[-3 2 1]); % serving cell at the 1st place, Pathloss ascend, cell id ascend
    elseif strcmp(criteria, 'rscp')
        cell=sortrows(cell,[-3 -2 1]); % serving cell at the 1st place, rscp descend, cell id ascend / 强度降序，邻区ID升序排列
    end                                % 顺序代表优先级、正负号代表升序降序、数字代表相应列：标记降序排列（主小区行都放在邻区前面），强度SS降序排列，cellid升序排列
    
    tt=cell(:,1)==-1;  %如果小区ID是-1，直接认为数据非法，删除该行。
    cell(tt,:)=[];
    
    %把重复的小区信息删除，只保留路损最小或者强度最大的那个小区的信息。
    [b n]=unique(cell(:,1),'first');    % 向量中的唯一的元素 b = A(n,:)
    n=sort(n);
    tmp_cell=-ones(1,7);
    tmp_ss=-ones(1,7);
    tmp_cell(1:length(n))=cell(n,1)';
    tmp_ss(1:length(n))=cell(n,2)';
    measurement(i,[SC_COL NB_COL])=tmp_cell;
    measurement(i,SS_COL)=tmp_ss;
end


