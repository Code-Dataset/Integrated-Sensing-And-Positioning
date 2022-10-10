function [ RadiusWeight ] = calculateRTTweight(referenceMeasurement, positioningRequest, cellInfo)
%  calculate the weight for GSM based on the difference between reference
%  fingerprint radius and TA radius 
%  Input: referenceMeasurement,
%         positioningRequest, cellInfo
%  outPut:  RadiusWeight of each reference fingerprint
ImportedDataFormat;
iAecidSystemConfigurations;

%calculate the distance between reference fingerprint and serving cell
%antenna of request fingerprint
[DistancebtRef2cell] = DistancebetweenMeas2Cell(referenceMeasurement,positioningRequest(1,SC_COL), cellInfo);

%calculate the actual distance between request fingerprint to its serving
%cell center
[RealRadius] = DistancebetweenMeas2Cell(positioningRequest,positioningRequest(1,SC_COL), cellInfo);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% begin for estimating the position based on RTT. there is no RTT report
%%% data for the request fingerprint in our simulate. so we have to simulate 
%%% RTT error according to existing RTT Error CDF
[RealRadius] = DistancebetweenMeas2Cell(positioningRequest,positioningRequest(1,SC_COL), cellInfo);

RandomstartIndex = 20;

global iteration

iteration = iteration + 1;

RTTError = [-210:9:-138   -130:1.8:23  40:30:160];   %  suburban CDF
%RTTError = [-210:5:-115   -110:1.5:-6.5    0:15:140]; %  rual CDF
%RTTError = -197.5:2.5:50;                        %urban CDF


% estimated radius according RTT
EstRTTRadius  = RealRadius + RTTError(mod(RandomstartIndex+iteration, 100)+1);

if EstRTTRadius<10
    EstRTTRadius = 10;
end

%%% end for estimating the position based on RTT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RadiusDiff =  EstRTTRadius-DistancebtRef2cell;
RadiusWeight = ones(length(DistancebtRef2cell),1);

  
RadiusWeight1 = (RTTDownBound-RadiusDiff)*RTTDownCoe;  
RadiusWeight1(find(RadiusWeight1<0)) = 0;
  
  
RadiusWeight2 = (RadiusDiff-RTTUpbound)*RTTUpCoe;  
RadiusWeight2(find(RadiusWeight2<0)) = 0;
  
RadiusWeight = RadiusWeight + RadiusWeight1 + RadiusWeight2;
    

end

