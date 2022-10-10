% Convert ENU to lat long in radian with reference point
% Input: ENU coordinates matrix,
%        refPoint, [lat long] in radian
%
% Output: lat long matrix in radian
function pointsLatLong = convertenu2latlong(pointsENU, refPoint)
majorAxisEarth = 6378137.0; % Double, Unit [meter]: Major axis of WGS 84 earth ellipsoid
minorAxisEarth = 6356752.314; % Double, Unit [meter]: Minor axis of WGS 84 earth ellipsoid
f=1-minorAxisEarth/majorAxisEarth; % Double, Unit [-]. Parameter in WGS 84 transformation, reference NIMA TR8350.2
eSquared=2*f-f*f; % Double, Unit [-]. Parameter in WGS 84 transformation, reference NIMA TR8350.2

aSizeOfCluster=length(pointsENU(:,1));
pointsECEF=zeros(aSizeOfCluster,3);
pointsLatLong=zeros(aSizeOfCluster,2);
N = majorAxisEarth/sqrt(1-eSquared*(sin(refPoint(1,1)))^2); % Re-used variable in coordinate transformation
refPointECEF(1,1) = N*cos(refPoint(1,1))*cos(refPoint(1,2)); % ECEF x-coordinate of i:th cell polygon corner
refPointECEF(2,1) = N*cos(refPoint(1,1))*sin(refPoint(1,2)); % ECEF y-coordinate of i:th cell polygon corner
refPointECEF(3,1) = N*(minorAxisEarth/majorAxisEarth)^2*sin(refPoint(1,1)); % ECEF z-coordinate of i:th cell polygon corner, automatically on WGS 84 ellipsoid

% for i=1:aSizeOfCluster
%     pointsECEF(1,i) = refPointECEF(1,1)-sin(refPoint(1,2))*pointsENU(i,1)-sin(refPoint(1,1))*cos(refPoint(1,2))*pointsENU(i,2); % x ECEF center point coordinate
%     pointsECEF(2,i) = refPointECEF(2,1)+cos(refPoint(1,2))*pointsENU(i,1)-sin(refPoint(1,1))*sin(refPoint(1,2))*pointsENU(i,2); % y ECEF center point coordinate
%     pointsECEF(3,i) = refPointECEF(3,1)+cos(refPoint(1,1))*pointsENU(i,2); % z ECEF center point coordinate
%     
%     % Then transform to WGS 84 lat/long. The result is in radians
%     
%     N = sqrt(pointsECEF(1,i)^2+pointsECEF(2,i)^2+(pointsECEF(3,i)*majorAxisEarth^2/minorAxisEarth^2)^2); % Help variable in transformation
%     pointsLatSign(i,1) = sign(pointsECEF(3,i)); % Latitude sign of centerpoint
%     pointsLatLong(i,1) = pointsLatSign(i,1)*acos(sqrt((pointsECEF(1,i)^2+pointsECEF(2,i)^2)/N^2)); % Latitude of centerpoint
%     pointsLatLong(i,2) = atan2(pointsECEF(2,i),pointsECEF(1,i)); % Longitude of centerpoint
% end

pointsECEF(:,1) = refPointECEF(1,1)-sin(refPoint(1,2))*pointsENU(:,1)-sin(refPoint(1,1))*cos(refPoint(1,2))*pointsENU(:,2); % x ECEF center point coordinate
pointsECEF(:,2) = refPointECEF(2,1)+cos(refPoint(1,2))*pointsENU(:,1)-sin(refPoint(1,1))*sin(refPoint(1,2))*pointsENU(:,2); % y ECEF center point coordinate
pointsECEF(:,3) = refPointECEF(3,1)+cos(refPoint(1,1))*pointsENU(:,2); % z ECEF center point coordinate

N = sqrt(pointsECEF(:,1).^2+pointsECEF(:,2).^2+(pointsECEF(:,3)*majorAxisEarth^2/minorAxisEarth^2).^2); % Help variable in transformation
pointsLatSign = sign(pointsECEF(:,3)); % Latitude sign of centerpoint
pointsLatLong(:,1) = pointsLatSign.*acos(sqrt((pointsECEF(:,1).^2+pointsECEF(:,2).^2)./N.^2)); % Latitude of centerpoint
pointsLatLong(:,2) = atan2(pointsECEF(:,2),pointsECEF(:,1)); % Longitude of centerpoint