% Calculate similarity between positioningRequest and selected measurements
% 计算选出来的指纹记录的相似度
% Input: positioningRequest
%        measurements
%        cosite: the cell in this list will add weight for matched
%        "position" in the heard cells except rscp

function [measCandidate s]=SimilarityCalculation2(positioningRequest, measurements, criteria, cosite)
% Import configurations
ImportedDataFormat;
iAecidSystemConfigurations;

numberOfMeasurements=length(measurements(:,1));
s=zeros(numberOfMeasurements,1);
measCandidate = measurements;


%%%%%%get the avaiable number of cells in request fingerprint
positioningRequestSimple =[positioningRequest(1,[SC_COL NB_COL])' positioningRequest(1,SS_COL)'];
InvalidCellIndex = find(positioningRequestSimple(:,1) == -1);
if   isempty(InvalidCellIndex)
    MaxnumberofCell = MaxNeighborCellCalculated+1;
else
    
    MaxnumberofCell = InvalidCellIndex(1) -1;
end

%  对position request上报的measurement里面的最小电平值-7，作为最小电平值。 
%  对路损里面最大的+7 作为最大路损。 这2个值会被用于对RE 里面匹配不到的CELL进行惩罚。
if strcmp(criteria, 'rscp')   %rscp
  temp = positioningRequestSimple(:,2);
  minumStrength = min(temp(find(temp~=-1))) -7;
else   %pathloss
  temp = positioningRequestSimple(:,2);
  minumStrength = max(temp(find(temp~=-1))) +7;
end


for i=1:numberOfMeasurements
 
    CorrMapingInMeas = zeros(MaxnumberofCell,1);
    numberofcorresponding  =0;

    %  当REQ里面的CELL在MSR里面匹配到时，求出RSCP或者pathloss的差的平方和。
    %  如果REQ的主小区、最强邻区和MSR里面的主小区或者最强邻区相等，就对相似度进行奖励。
    %  如果REQ里面的CELL在MSR里面只要能找到3个，就不加惩罚，否则就将相似度加100。
    %  将最后的平方和除以REQ里面的小区数，得出最后的相似度。
    oneMeasurementSimple = [measCandidate(i,[SC_COL NB_COL])' measCandidate(i,SS_COL)'];
    numberofCorr = 0;
    totalCorr= 0;
    for j=1:MaxnumberofCell   %  轮询选出的MSR记录
          correspondingIndex = find(oneMeasurementSimple == positioningRequestSimple(j,1));   %  轮询REQ里面的小区ID，在MSR记录里面找到匹配的
          if isempty(correspondingIndex)      
            % hearable in the request fingerprint but not in reference fingerprint
            totalCorr = totalCorr + (positioningRequestSimple(j,2)-minumStrength).^2;    %  求出RSCP的差值平方，然后一个个小区相加。如果这个ID在MSR里面找不到，
                                                                                         %  就假设这个小区在MSR里面的RSCP值为REQ里面邻区最低电平值-7，或者邻区最大路损值+7，等于就是一个惩罚。                   
          else               
            % hearable in both the request fingerprint and reference fingerprint
            % Maybe size of correspondingIndex is greater than 1. so orrespondingIndex(1) is used instead of correspondingIndex
            totalCorr = totalCorr + (positioningRequestSimple(j,2)-oneMeasurementSimple(correspondingIndex(1),2)).^2;   %  找得到匹配的ID就不惩罚了，直接求平方。  
            CorrMapingInMeas(correspondingIndex,1)= 1;
            numberofcorresponding = numberofcorresponding+1;
          end   
          numberofCorr = numberofCorr +1;
    end
    
    % if serving cell is same, the possibility increases. 
    % 如果position request上报的主小区和路测报告的主小区一致，那么totalCorr就乘以3/4，如果最大信号的邻区互相一致，那么totalCorr也是乘以 3/4。交叉相等也可以。
    if oneMeasurementSimple(1,1) == cosite(1)
            totalCorr=totalCorr*3/4;
    end
    
   if oneMeasurementSimple(2,1) ==cosite(1)
            totalCorr=totalCorr*3/4;
   end
    
   if cosite(2)~=-1
       if oneMeasurementSimple(1,1) == cosite(2)
            
            totalCorr=totalCorr*3/4;
        end

       if oneMeasurementSimple(2,1) ==cosite(2)
                totalCorr=totalCorr*3/4;
       end
   end
    
   
    % 如果当REQ中的小区ID和MSR中的CELLID匹配数>3,不做惩罚，否则对相似度加100
    % when number of same cells is less than 3, add punishment value
    if numberofcorresponding >=3
      s(i,1)  = sqrt(totalCorr/numberofCorr);
      if s(i,1) < 0.1    % if it's 0, it results in infinite in the generateEllipseFromEigVector2.m 对相似度太小进行保护，否者后面求倒数会出问题。
          s(i,1) = 0.1;
      end
    else
        s(i,1) = PunishForInSufficientMapingCells + sqrt(totalCorr/numberofCorr);
    end
end
