function [ RadiusWeight ] = calculateTAweight(referenceMeasurement, positioningRequest, cellInfo)
%  calculate the weight for GSM based on the difference between reference
%  fingerprint radius and TA radius 
%  Input: referenceMeasurement,
%         positioningRequest, cellInfo
%  outPut:  RadiusWeight of each reference fingerprint
ImportedDataFormat;
iAecidSystemConfigurations;

%calculate the distance between reference fingerprint and serving cell
%center of request fingerprint
[DistancebtRef2cell] = DistancebetweenMeas2Cell(referenceMeasurement,positioningRequest(1,SC_COL), cellInfo);

RadiusWeight = ones(length(DistancebtRef2cell),1);
TARequest = positioningRequest(1, TA_COL);
TAIndexInLUT =  TARequest+1;
 
if TARequest > 3
    coedown=TaLUT(TAIndexInLUT,4);
    coeup = TaLUT(TAIndexInLUT,5);
    
 
    RadiusWeight1 = (DistancebtRef2cell-TaLUT(TAIndexInLUT,3))*coeup;  
    RadiusWeight1(find(RadiusWeight1<0)) = 0;
  
  
    RadiusWeight2 = (TaLUT(TAIndexInLUT,2) - DistancebtRef2cell)*coedown;  
    RadiusWeight2(find(RadiusWeight2<0)) = 0;
  
    RadiusWeight = RadiusWeight + RadiusWeight1 + RadiusWeight2;
else
     coeup = TaLUT(TAIndexInLUT,5);
     
     RadiusWeight1 = (DistancebtRef2cell-TaLUT(TAIndexInLUT,3))*coeup;  
     RadiusWeight1(find(RadiusWeight1<0)) = 0;
     
     RadiusWeight = RadiusWeight + RadiusWeight1;
     
end

end

