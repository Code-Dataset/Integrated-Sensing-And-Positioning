% Get initial points that would be involved in similarity calculation
% 在获取相似度计算中找到初始MSR
% Input: positioningRequest
%        measurements
%        criteria: 1 for select by cell id
%                  2 for select by location (didn't implemented)
%        cellInfo: cell information

function [m similarity weightedCell]=PointsInitiation(positioningRequest, measurements, flag, criteria, cellInfo)
ImportedDataFormat;
iAecidSystemConfigurations;
m=measurements;
sc_id=positioningRequest(1,SC_COL);
NbCell=positioningRequest(1,NB_COL);
nb1_id=NbCell(1);
weightedCell=[sc_id;nb1_id];  
[m similarity]=SimilarityCalculation2(positioningRequest, m, criteria, weightedCell);