% Generate location estimations for a bunch of location requests
% Leo: [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(UrbanPredict, Measurement, 'rscp', celldata_LTE_new,'')

% chu: [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(test_req, new_test_dataset, 'rscp', celldata_LTE_new,'')
% chu: [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(test_req, new_test_dataset_res_deleteindoor_deleteres, 'rscp', celldata_LTE_new,'')
% chu: [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(test_req, RD1, 'rscp', celldata_LTE_new,'')

% chu: [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(test_req, new_DIMIO_test_dataset, 'rscp', celldata_LTE_new,'')
% chu: [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(test_req, new_MIO_test_dataset, 'rscp', celldata_LTE_new,'')
% chu: [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(test_req, new_O_test_dataset, 'rscp', celldata_LTE_new,'')

% chu: [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(RD_req, new_test_dataset, 'rscp', celldata_LTE_new,'')
% chu: [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(RD_req, new_test_dataset_res_deleteindoor_deleteres, 'rscp', celldata_LTE_new,'')
function [error Ellipse SimilarMeasurements numAllMeasurements]=iAecidTest(positioningRequest, measurements, criteria, cellInfo, googlemap)
ImportedDataFormat;
numRequest=length(positioningRequest(:,1));
Ellipse=NaN(numRequest,6);
error=zeros(numRequest,5);
indexOfFail = 1;

tic
t1=clock;
% matlabpool local 8
for i=1:numRequest
% for i=1:50
    if nargin == 5
        [Ellipse(i,:) conf S N errorCode]=iAecidMain(positioningRequest(i,:), measurements, criteria, cellInfo, googlemap);
    else
        [Ellipse(i,:) conf S N errorCode]=iAecidMain(positioningRequest(i,:), measurements, criteria, cellInfo);
        %[Ellipse(i,:) S conf]=iAecidMain_impl(positioningRequest(i,:), measurements, cellInfo);
    end

    if ~isnan(Ellipse(i,1))
        centerET=convertlatlong2enu(Ellipse(i,[CENTER_LAT_COL CENTER_LONG_COL]), positioningRequest(i,[LAT_COL LONG_COL])*pi/180);  % 中心点经纬度换为坐标（以定位请求的弧度为原点）
        % Success flag
        error(i,1)=1;
        % 2D error
        error(i,2)=sqrt(centerET(1,1)^2+centerET(1,2)^2); % 中心点距离原点（定位请求）的距离
        % If estimation is in ellipse
        centerETAfterRotation = CoordinatesRotation(centerET, Ellipse(i,ORIENTATION_COL));
        if (centerETAfterRotation(1)^2/Ellipse(i,SEMIMAJOR_COL)^2+centerETAfterRotation(2)^2/Ellipse(i,SEMIMINOR_COL)^2) <= 1
           error(i,3) = 1;
        end
        % Confidence
        error(i,4)=conf;
        
        SimilarMeasurements{i,1}=S;
        numAllMeasurements(i,1)=N;
    else
        % Error Type; legacy codes
        error(i,5)=errorCode;
        SimilarMeasurements{i,1}=S;
        numAllMeasurements(i,1)=N;
        minDistanceOfRef(indexOfFail) = conf;
        indexOfFail=indexOfFail+1;
    end
end
toc
disp(['运行时间:',num2str(toc)]);
% matlabpool close
t2=clock;
t3=etime(t2,t1)

 minDistanceOfRef = sort(minDistanceOfRef);
 plot([0;minDistanceOfRef'],[0:length(minDistanceOfRef)]/length(minDistanceOfRef),'color','g','LineWidth',2);
 hold on;
 grid on;
 