% Convert lat long in radian to ENU with reference point 
% Input: lat long matrix in radian
%        refPoint, reference point in radian
%
% Output: ENU coordinates matrix
function myReferencePointsET = convertlatlong2enu(theLLPoints, refPoint)
% Constants
EAST=1;
NORTH=2;

%Transform cluster points in LL to ET(ENU)
majorAxisEarth = 6378137.0; % Double, Unit [meter]: Major axis of WGS 84 earth ellipsoid
minorAxisEarth = 6356752.314; % Double, Unit [meter]: Minor axis of WGS 84 earth ellipsoid
f=1-minorAxisEarth/majorAxisEarth; % Double, Unit [-]. Parameter in WGS 84 transformation, reference NIMA TR8350.2
eSquared=2*f-f*f; % Double, Unit [-]. Parameter in WGS 84 transformation, reference NIMA TR8350.2

aSizeOfCluster = length(theLLPoints(:,1));

myReferencePointECEF=zeros(aSizeOfCluster,3);
myReferencePointsET = zeros(aSizeOfCluster,2);
for i=1:aSizeOfCluster
    N = majorAxisEarth/sqrt(1-eSquared*(sin(theLLPoints(i,1)))^2); % Re-used variable in coordinate transformation
    myReferencePointECEF(i,1) = N*cos(theLLPoints(i,1))*cos(theLLPoints(i,2)); % ECEF x-coordinate of i:th reference point
    myReferencePointECEF(i,2) = N*cos(theLLPoints(i,1))*sin(theLLPoints(i,2)); % ECEF y-coordinate of i:th reference point
    myReferencePointECEF(i,3) = N*(minorAxisEarth/majorAxisEarth)^2*sin(theLLPoints(i,1)); % ECEF z-coordinate of i:th reference point
end

N = majorAxisEarth/sqrt(1-eSquared*(sin(refPoint(1,1)))^2); % Re-used variable in coordinate transformation
refPointECEF(1,1) = N*cos(refPoint(1,1))*cos(refPoint(1,2)); % ECEF x-coordinate of i:th reference point
refPointECEF(1,2) = N*cos(refPoint(1,1))*sin(refPoint(1,2)); % ECEF y-coordinate of i:th reference point
refPointECEF(1,3) = N*(minorAxisEarth/majorAxisEarth)^2*sin(refPoint(1,1)); % ECEF z-coordinate of i:th reference point


for i=1:aSizeOfCluster
    myReferencePointsET(i,EAST) = -sin(refPoint(1,2))*(myReferencePointECEF(i,1)-refPointECEF(1,1))+cos(refPoint(1,2))*(myReferencePointECEF(i,2)-refPointECEF(1,2)); % ET east Cartesian coordinate
    myReferencePointsET(i,NORTH) = -sin(refPoint(1,1))*cos(refPoint(1,2))*(myReferencePointECEF(i,1)-refPointECEF(1,1))-sin(refPoint(1,1))*sin(refPoint(1,2))*(myReferencePointECEF(i,2)-refPointECEF(1,2))+cos(refPoint(1,1))*(myReferencePointECEF(i,3)-refPointECEF(1,3)); % ET north Cartesian coordinate
end