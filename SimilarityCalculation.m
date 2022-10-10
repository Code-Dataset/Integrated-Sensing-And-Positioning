% Calculate similarity based on received rscp and heard cell order
%
% Input: positioningRequest
%        measurements
%        cosite: the cell in this list will add weight for matched
%        "position" in the heard cells except rscp

function s=SimilarityCalculation(positioningRequest, measurements, cosite)
% Import configurations
ImportedDataFormat;
iAecidSystemConfigurations;

numberOfMeasurements=length(measurements(:,1));
s=zeros(numberOfMeasurements,1);
% Calculate similarity between positioningRequest and selected measurements

%%%%%%%%%%%% Serving Cell %%%%%%%%%%%%%%%%%
t=(measurements(:,SC_COL)==positioningRequest(1,SC_COL));
if sum(t)~= 0
    s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(1)), measurements(t,SS_COL(1)));
end
for i=1:MaxNeighborCellCalculated
    t=(measurements(:,NB_COL(i))==positioningRequest(1,SC_COL));
    if sum(t)~=0
        s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(1)), measurements(t,SS_COL(i+1)));
    end  
end

%%%%%%%%%%%%% Neighbor Cell %%%%%%%%%%%%%%%%%%%
for i=1:MaxNeighborCellCalculated
    if positioningRequest(1,NB_COL(i))==-1
        break
    else
        t=measurements(:,SC_COL)==positioningRequest(NB_COL(i));
        if sum(t)~=0
            s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(i+1)),measurements(t,SS_COL(1)));
        end
        for j=1:MaxNeighborCellCalculated
            t=measurements(:,NB_COL(j))==positioningRequest(NB_COL(i));
            if sum(t)~=0
                s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(i+1)),measurements(t,SS_COL(j+1)));
            end
        end
    end
end

%%%%%%%%%%%Add weight for "order"
for i=1:length(cosite)
    if cosite(i)~=-1
        t=measurements(:,SC_COL)==cosite(i);
        if sum(t)~=0
            s(t)=s(t)+SC_OrderWeight;
        end
        t=measurements(:,NB_COL(1))==cosite(i);
        if sum(t)~=0
            s(t)=s(t)+SC_OrderWeight;
        end
    end
end

% %%%%%%%%%%%% Serving Cell %%%%%%%%%%%%%%%%%
% t=(measurements(:,SC_COL)==positioningRequest(1,SC_COL));
% if sum(t)~= 0
%     s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(1)), measurements(t,SS_COL(1)))+SC_OrderWeight;
% end
% for i=1:MaxNeighborCellCalculated
%     t=(measurements(:,NB_COL(i))==positioningRequest(1,SC_COL));
%     if sum(t)~=0
%         s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(1)), measurements(t,SS_COL(i+1)));
%         % SC == NB1
%         if i==1
%             s(t)=s(t)+SC_OrderWeight;
%         end
%     end  
% end
% 
% %%%%%%%%%%%%% Neighbor Cell %%%%%%%%%%%%%%%%%%%
% for i=1:MaxNeighborCellCalculated
%     if positioningRequest(1,NB_COL(i))==-1
%         break
%     elseif i==1
%         %NB1=SC
%         t=measurements(:,SC_COL)==positioningRequest(1,NB_COL(1));
%         if sum(t)~=0
%             s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(2)), measurements(t,SS_COL(1)))+SC_OrderWeight;
%         end
%         %NB1=NB1
%         t=measurements(:,NB_COL(1))==positioningRequest(1,NB_COL(1));
%         if sum(t)~=0
%             s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(2)), measurements(t,SS_COL(2)))+SC_OrderWeight;
%         end
%         
%         for j=2:MaxNeighborCellCalculated
%             t=measurements(:,NB_COL(j))==positioningRequest(1,NB_COL(1));
%             if sum(t)~=0
%                 s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(2)),measurements(t,SS_COL(j+1)));
%             end
%         end
%     else
%         for j=1:MaxNeighborCellCalculated
%             t=measurements(:,NB_COL(j))==positioningRequest(NB_COL(i));
%             if sum(t)~=0
%                 s(t)=s(t)+RscpSimilarityCalculation(positioningRequest(1,SS_COL(i+1)),measurements(t,SS_COL(j+1)));
%             end
%         end
%     end
% end