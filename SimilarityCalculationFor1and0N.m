% Calculate similarity between positioningRequest and selected measurements
% Input: positioningRequest
%        measurements
%        cosite: the cell in this list will add weight for matched
%        "position" in the heard cells except rscp

function [measCandidate s]=SimilarityCalculationFor1and0N(positioningRequest, measurements, numofNB)
% Import configurations
ImportedDataFormat;
iAecidSystemConfigurations;

numberOfMeasurements=length(measurements(:,1));
s=zeros(numberOfMeasurements,1);

measCandidate = measurements;


if numofNB ==0   % no neighboring cell, only serving cell
    for i=1:numberOfMeasurements
        s(i,1)  = abs(positioningRequest(1,SS_COL(1))-measurements(i,SS_COL(1)));
%       if s(i,1) < 0.1 
%         s(i,1)=0.1; 
%       end
%   对相似度太小进行保护，否者后面求倒数会出问题。
    end    
else      % 1 serving cell+ 1 neighboring cell
    for i=1:numberOfMeasurements
        totalCorr = (positioningRequest(1,SS_COL(1))-measurements(i,SS_COL(1))).^2+...
            (positioningRequest(1,SS_COL(2))-measurements(i,SS_COL(2))).^2;
        s(i,1)  = sqrt(totalCorr/2);
    end    
end  %  惩罚逻辑没有了
end
