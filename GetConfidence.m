% Get confidence of the selected points (might be changed)
% Input: sizeOfCluster: number of selected points
%        ConfidenceSchem
% Output: confidence
function confidence = GetConfidence(sizeOfCluster, ConfidenceScheme)
index = find(ConfidenceScheme(:,2)>=sizeOfCluster, 1, 'first');
confidence = ConfidenceScheme(index, 3);