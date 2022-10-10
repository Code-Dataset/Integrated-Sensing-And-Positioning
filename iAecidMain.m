% iAecid main function, generate location estimate for a single positioning
% request
%
% Input: positioningRequest
%        measurements, reference points (or gridmap)
%
% Output: Ellipse, location estimate, SimilarMeasurements, selected similar measurements (for result anaylysis)

function [Ellipse confidence SimilarMeasurements numAllMeasurements errorCode]=iAecidMain(positioningRequest, measurements, criteria, cellInfo, googlemap)
% Import configurations（导入配置）
ImportedDataFormat;
iAecidSystemConfigurations;
confidence=0;
errorCode=0;
numAllMeasurements=0;

%% select initial points with calculated similarities（选择具有计算相似度的初始点）
positioningRequest=RemoveReplicatedCell(positioningRequest,criteria);  % 对REQ进行合法性检查
tic;
t1=clock;
[initMeasurements similarity weightedCell]=PointsInitiation(positioningRequest, measurements, 1, criteria, cellInfo);  % 初筛(邻区数量、RSRP)  计算相似度(微调 惩罚)
tic;
t2=clock;
etime(t2,t1);

if isempty(initMeasurements)
    Ellipse=NaN(1,6);
    SimilarMeasurements=[];
    errorCode=1; %No first batch
    candicateMeas = [];
    return
end
numAllMeasurements=length(initMeasurements(:,1));

if  numAllMeasurements>50            %如果筛选出来的路测记录大于 50，取相似度最好的 50 条记录
    column = length(initMeasurements(1,:));
    initMeasurements = [initMeasurements similarity];
    initMeasurements = sortrows(initMeasurements,[column+1 LONG_COL LAT_COL]);
    initMeasurements = initMeasurements(1:50,:);  
    similarity = initMeasurements(1:50,column+1);
end

%% 根据TA调整相似度
if TARTTTurnOnOff == 1   % 0 means off, 1 means on
    switch SystemConfigureOption   % 0 means GSM,1 means WCDMA,2means LTE；SystemConfigureOption  = 2; 
        case 0   % GSM
            RadiusWeight = calculateTAweight(initMeasurements,positioningRequest, cellInfo);
        case 1   % wcdma
            RadiusWeight = calculateRTTweight(initMeasurements,positioningRequest, cellInfo);
        case 2   % lte
            RadiusWeight = calculateLTETAweight(initMeasurements,positioningRequest, cellInfo);   % 权重
    end 

    similarity = similarity.*RadiusWeight;  % 根据MSR记录位置和TA的差异调整相似度

end 

%% Convert measurements from Lat/Long to ENU   经纬高坐标系的弧度→东-北-天坐标系ENU中各条指纹相对于第一条指纹的坐标
refPoint=initMeasurements(1,[LAT_COL LONG_COL])*pi/180;  % 经纬度转为弧度
initMeasurementsET=convertlatlong2enu(initMeasurements(:,[LAT_COL LONG_COL])*pi/180, refPoint);  % initMeasurementsET有两列分别为两个方向上的坐标

%% 对最终相似度排序，选出前N名
% Calculate similarity for every points
% similarity=SimilarityCalculation(positioningRequest, initMeasurements);
initMeasurementsET=[initMeasurementsET similarity];  %将筛选出来的路测记录矩阵ET加上相似度作为最后一列
% Sort the similarity in descend order
uniqueSimilarity=sort(unique(similarity),'ascend');  %将相似度降序排列，去掉重复的

tt=[];

% if more than  MaxNumSimilarPointsThreshold reference measurememnts are found, break;
% （MaxNumSimilarPointsThreshold=8）选出K条最相似记录

% if reference measurements similarity is bigger than MaxSimilarityThreshold2, break（MaxSimilarityThreshold2=8）
% when simimarity of reference measurements and request measurement is less than MaxSimilarityThreshold2, it's similar measurement. otherwise, not
for i=1:length(uniqueSimilarity)
    similarityThreshold=uniqueSimilarity(i);
     if similarityThreshold >= MaxSimilarityThreshold2    
         break;
    end
 
    tt=(similarity<=similarityThreshold);
     
    if sum(tt)>=MaxNumSimilarPointsThreshold   %MaxNumSimilarPointsThreshold=8
        break 
    end
end


if sum(tt) <minNumOfSimilarMeas   % minNumOfSimilarMeas = 1，when less than it, positioning is failed.
    %sum(tt)
    Ellipse=NaN(1,6);
    SimilarMeasurements=[];
    confidence=0;
    errorCode=2; %No enough similar measurements
    return
end


%% 根据最后筛选出来的MSR记录条数确定定位的confidence
% Get confidence according to the number of similar points
confidence_num=ConfidenceSchema_num(find(sum(tt)>=ConfidenceSchema_num(:,1),1,'first'),2); 
confidence=(confidence_num);   
% ConfidenceSchema_num = [ 500 0.95; 240 0.90; 120 0.85; 60 0.80; 30 0.75; MinNumSimilarPointsThreshold 0.70; 1 0.30; ];

similarMeasurementsET=initMeasurementsET(tt,:);
SimilarMeasurements = initMeasurements(tt,:);   %把路测记录的测量报告中的经纬度转换为ENU坐标系，同时更新相似度，然后按照相似度升序排列
% SimilarMeasurements(:,LAT_COL) = similarMeasurementsET(:,1);
% SimilarMeasurements(:,LONG_COL) = similarMeasurementsET(:,2);
SimilarMeasurements(:,19) = similarMeasurementsET(:,3);   %第19列为相似度，并排序
SimilarMeasurements = sortrows(SimilarMeasurements,19);


%% 根据WKNN计算最终位置和椭圆
% Get the ellipse as the location estimate
if isnan(similarMeasurementsET(1,3))
    return;
end

% if length(similarMeasurementsET(:,1))>=2
    Ellipse=generateEllipseFromEigVector2(similarMeasurementsET,confidence,refPoint);  % 根据WKNN，生成一个椭圆，返回椭圆中心点，长短轴，旋转角，conf
%  else
%    Ellipse(1,CENTER_LAT_COL) = SimilarMeasurements(1,LAT_COL)*pi/180;
%    Ellipse(1,CENTER_LONG_COL) = SimilarMeasurements(1,LONG_COL)*pi/180;
%    Ellipse(1,SEMIMAJOR_COL) = estimatedCircleRadius;       % estimatedCircleRadius = 100
%    Ellipse(1,SEMIMINOR_COL) = estimatedCircleRadius;
%    Ellipse(1,ORIENTATION_COL) = 0;
%    Ellipse(1,CONFIDENCE_COL) = 0.3;
%end

end

