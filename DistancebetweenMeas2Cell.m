function [ Distance] = DistancebetweenMeas2Cell(Measurements,cellId, cellInfo)
% calculate the distance between the measurement and cell center which is defined
% input: Measurements,
%        cellId, cellInfo       
% output: Distance
%
ImportedDataFormat;
iAecidSystemConfigurations;

%find the cell position
[cellrow, cellcolumn] = size(cellInfo);

cellPosition = NaN(1,cellcolumn);

 for k=1:cellrow
       if cellInfo(k,CELL_ID) == cellId
            %cell position
            cellPosition=cellInfo(k,[CELL_LAT CELL_LONG])*pi/180;   
            break;
       end        
 end 
 
if ~isnan(cellPosition)
        MeasPosition=Measurements(:,[LAT_COL LONG_COL])*pi/180;
            
        %the distance between the measure and cell center.            
        measCoor = convertlatlong2enu(MeasPosition, cellPosition);            
        Distance = sqrt(measCoor(:,1).^2 + measCoor(:,2).^2); 
else
        Distance  = NaN;
end 

end

