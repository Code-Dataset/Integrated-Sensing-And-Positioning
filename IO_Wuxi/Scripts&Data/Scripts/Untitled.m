clear all,close all,clc;

load('IndoorDatawithGPS.mat');
load('cellnewest.mat');

number = 22;

a1 ='DadiCinimaRoom7';
a2 ='FamilyMart'; 
a3 ='Hotel18thFloor'; 
a4 ='HotelLobby'; 
a5 ='HSRonBoard'; 
a6 ='HSRStation'; 
a7 ='IndoorMovingGrandOrientalAF12345'; 
a8 ='IndoorMovingGrandOrientalB'; 
a9 ='IndoorMovingYunfu'; 
a10='IndoorSunningPlazaMix'; 
a11='IndoorSunningPlazaStationary'; 
a12='MovingHotelLobby'; 
a13='NanjingBank'; 
a14='StationaryHotelF18'; 
a15='StationaryHotelLobby'; 
a16='YunfuIndF123'; 
a17='YunfuIndF35'; 
a18='YunfuIndF4'; 
a19='YunfuIndF5'; 
a20='YunfuIndF6'; 
a21='YunfuIndF7'; 
a22='YunfuIndoorStationary';

b1 ='adiCinimaRoom7';
b2 ='amilyMart'; 
b3 ='otel18thFloor'; 
b4 ='otelLobby'; 
b5 ='SRonBoard'; 
b6 ='SRStation'; 
b7 ='ndoorMovingGrandOrientalAF12345'; 
b8 ='ndoorMovingGrandOrientalB'; 
b9 ='ndoorMovingYunfu'; 
b10='ndoorSunningPlazaMix'; 
b11='ndoorSunningPlazaStationary'; 
b12='ovingHotelLobby'; 
b13='anjingBank'; 
b14='tationaryHotelF18'; 
b15='tationaryHotelLobby'; 
b16='unfuIndF123'; 
b17='unfuIndF35'; 
b18='unfuIndF4'; 
b19='unfuIndF5'; 
b20='unfuIndF6'; 
b21='unfuIndF7'; 
b22='unfuIndoorStationary';

bbbb = 1;
save('GPSinfo.mat','bbbb');

for ii = 1:number
    eval(['tempa = a', num2str(ii), ';']);
    eval(['tempb = b', num2str(ii), ';']);
    eval([tempb, ' = ', tempa, '(:,18:-1:17);']);
    save('GPSinfo.mat', tempb, '-append');
end

load('GPSinfo.mat');
load('hhh.mat');

bbbb = 1;
save('Indoordata_GPS.mat','bbbb');

for ii = 1:number
    
    eval(['tempa = a', num2str(ii), ';']);
    eval(['tempb = b', num2str(ii), ';']);
    
    eval([tempa, '(:,2:3) = ', tempb, ';']);    
    eval([tempa, '  =   convertmeasurement(', tempa, ', celldata_LTE);']);
    eval([tempa, '(:,30) = [];']);
    save('Indoordata_GPS.mat', tempa, '-append');

end





