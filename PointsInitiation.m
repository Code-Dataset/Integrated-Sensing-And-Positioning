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
if flag == 1    %Select by cells
    sc_id=positioningRequest(1,SC_COL);
    NbCell=positioningRequest(1,NB_COL);
    nb1_id=NbCell(1);
    numofNB=sum(NbCell~=-1);
    if nargin==4 | isempty(cellInfo)
        sc_ss=positioningRequest(1,SS_COL(1));
        nb1_ss=positioningRequest(1,SS_COL(2));
        
        kk=measurements(:,SC_COL) == sc_id | ...
                measurements(:,SC_COL) == nb1_id | ...
                measurements(:,NB_COL(1)) == nb1_id | ...
                measurements(:,NB_COL(1)) == sc_id;
        weightedCell=[sc_id;nb1_id];            
        
        
        m=measurements(kk,:);
        [m similarity]=SimilarityCalculation2(positioningRequest, m, criteria, weightedCell);
    elseif nargin==5
        
        sc_ss=positioningRequest(1,SS_COL(1));
        nb1_ss=positioningRequest(1,SS_COL(2));
        %  当REQ里面邻区数据大于等于2时，只要MSR主小区的SC或者NB1和REQ里面的SC或者NB1的ID相同，这条记录就被选中
        if numofNB>=2     
            kk=measurements(:,SC_COL) == sc_id | ...
                measurements(:,SC_COL) == nb1_id | ...
                measurements(:,NB_COL(1)) == nb1_id | ...
                measurements(:,NB_COL(1)) == sc_id;
            weightedCell=[sc_id;nb1_id];
            m=measurements(kk,:);
           [m similarity]=SimilarityCalculation2(positioningRequest, m, criteria, weightedCell);
        %  如果REQ里面邻区数目为1，首先尝试找到MSR里面邻区数目也为1的记录，然后严格要求MSR里面的SCID和REQ里面的SCID相等，MSR里面的NBID和REQ里面的NB1ID相等。
        %  如果这样找不到符合要求的MSR。就做一下尝试，还是要求SCID和NB1ID严格相等。
        %  注意邻区数目大于等于2的时候是可以交叉相等的。但是不再要求MSR只有一个邻区，可以有2个邻区，但是要求NB2的电平必须必SCSS小20.或者NB2的 路损必须必SCLOSS大20.
        else   
            if numofNB==1     
                % fully matching
                kk=measurements(:,SC_COL) == sc_id & ...
                    measurements(:,NB_COL(1)) == nb1_id &...
                     measurements(:,NB_COL(2)) ==-1;
                if sum(kk) == 0                                         
                    if strcmp(criteria, 'rscp')   %rscp
                        minSS = sc_ss-MaxPathDiffForDect;
                        kk=measurements(:,SC_COL) == sc_id & ...
                           measurements(:,NB_COL(1)) == nb1_id& ...
                           measurements(:,SS_COL(3))<minSS;
                    else   %pathloss
                        maxPathloss = sc_ss+MaxPathDiffForDect;
                        kk=measurements(:,SC_COL) == sc_id & ...
                            measurements(:,NB_COL(1)) == nb1_id& ...
                            measurements(:,SS_COL(3))>maxPathloss;
                    end                                                       
                end
                 weightedCell=[sc_id;nb1_id];
                 m=measurements(kk,:);
                 
                [m similarity]=SimilarityCalculationFor1and0N(positioningRequest, m, 1);
           %  如果一个邻区都没有，做法和一个邻区类似，首先要求REQ和MSR间的SCID完全一致，且MSR也没有邻区。 
           %  如果找不到匹配的MSR，就去找只有一个邻区的MSR，要求MSR的SCID==REQ的SCID，且MSR的邻区1的SS比主小区的SS高很多，或者路损低很多。
            else
                kk=measurements(:,SC_COL) == sc_id & ...
                    measurements(:,NB_COL(1)) == -1 ;
                
                if sum(kk) == 0                                         
                    if strcmp(criteria, 'rscp')   %rscp
                      minSS = sc_ss-MaxPathDiffForDect;
                      kk=measurements(:,SC_COL) == sc_id & measurements(:,SS_COL(2))<minSS;
                    else   %pathloss
                      maxPathloss = sc_ss+MaxPathDiffForDect;
                      kk=measurements(:,SC_COL) == sc_id & measurements(:,SS_COL(2))>maxPathloss;
                    end                                                       
                end
                weightedCell=[sc_id];
                 m=measurements(kk,:);
                [m similarity]=SimilarityCalculationFor1and0N(positioningRequest, m, 0);
            end

       
        end
    end
  
elseif flag == 2    %Select by location

elseif flag == 3    %For virtual data, involve all the measurements
    
    sc_id=positioningRequest(1,SC_COL);
    nb1_id=positioningRequest(1,NB_COL(1));
        cosite=[sc_id;nb1_id];
        tt=cellInfo(:,CELL_ID)==sc_id;
        if sum(tt)>0
            servingCell=cellInfo(tt,:);
        else
            servingCell=[];
        end
        m=measurements;
        [m similarity]=SimilarityCalculation2(positioningRequest, m, criteria,cosite);   %  计算选出来的指纹记录的相似度
end