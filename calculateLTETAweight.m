function [ RadiusWeight ] = calculateLTETAweight(referenceMeasurement, positioningRequest, cellInfo)
%  calculate the weight for LTE based on the difference between reference fingerprint radius and TA radius 
%  Input: referenceMeasurement,
%         positioningRequest, cellInfo
%  outPut: RadiusWeight of each reference fingerprint
ImportedDataFormat;
iAecidSystemConfigurations;

%calculate the distance between reference fingerprint and serving cell
%center of request fingerprint
[DistancebtRef2cell] = DistancebetweenMeas2Cell(referenceMeasurement,positioningRequest(1,SC_COL), cellInfo);  %在小区数据里面找到position request里面的主小区的经纬度。然后计算和MSR数据的距离

RadiusWeight = ones(length(DistancebtRef2cell),1);

% TA<=20做了修正，没有用这个定义，要查内插表
if positioningRequest(1, params.TA_COL)<=20      
    TACenter=LTETAQuantizationSchema(positioningRequest(1, params.TA_COL)+1,2); 
    GaussianDis = LTETAQuantizationSchema(positioningRequest(1, params.TA_COL)+1,3);  %LTETAQuantizationSchema为空，在iAecidSystemConfigurations中有
% 如果TA>20的话，就是直接用TA乘以78，加上一个修正，因为16TS是156，78就等于把距离折半变成单程距离了。
else
    TACenter = positioningRequest(1, params.TA_COL)*LTETA2DistanceUnit+LTETACorrectionValue;  % LTETA2DistanceUnit = 78; LTETACorrectionValue = -30
    GaussianDis = LTETADeviation;  % Gaussian deviation, default is 200m.
end

% 将position request里面的主小区和路测数据里面小区的距离和上报的TA值做个对比,然后算出权重。
% 如果和TA范围一致，权重就是1，如果不一致，权重会有所调整。 
% 如果主小区和参考点的距离大于TA的范围，就把多出范围的部分乘以0.003加入权重1，作为距离权重。
% 如果主小区和参考点的距离小于TA的范围，就把多出范围的部分乘以0.006加入权重1，作为距离权重。
    coedown=0.006;
    coeup = 0.003;
 
    RadiusWeight1 = (DistancebtRef2cell-(TACenter+GaussianDis))*coeup;  
    RadiusWeight1(find(RadiusWeight1<0)) = 0;
  
    RadiusWeight2 = ((TACenter-GaussianDis)- DistancebtRef2cell)*coedown;  
    RadiusWeight2(find(RadiusWeight2<0)) = 0;
  
    RadiusWeight = RadiusWeight + RadiusWeight1 + RadiusWeight2;
end

