% data format used in the prototype
global params;

params = struct(... 
'INDEX_COL',1 ,... % serial number
 'SC_COL', 2 ,... % serving cell ID
 'TA_COL', 3 ,... % reported TA
 'SS_COL', [4 6 8 10 12 14 16] ,... % signal strength index
 'NB_COL', [5 7 9 11 13 15] ,... % neighbor cell ID index
 'LAT_COL', 18,... % latitude of ground truth
 'LONG_COL', 17 ,... % longitude of ground truth
 'ALT_COL', 19 ,...% % altitude of ground truth
 'DIS_TO_CELL', 20 ,... % the distance to the serving cell antenna
 'COSITE_FLAG', 21 ,... % 1: includes cosites cells   -1: not 
 'TIME', 25,.....       % Time
 'SPEED', 26, .....     % Speed
 'S_RSRQ', 27, ....      % serving cell RSRQ
 'CENTER_LAT_COL', 1 ,... % below 5 params are for positioning result format.
 'CENTER_LONG_COL', 2 ,...
 'SEMIMAJOR_COL', 3 ,...
 'SEMIMINOR_COL', 4 ,...
 'ORIENTATION_COL', 5 ,...
 'CONFIDENCE_COL', 6 ,... % above are measurement format
 'CELL_LAT', 1 ,... % Cell latitude, in degree
 'CELL_LONG', 2 ,... % Cell longitude, in degree
 'CELL_ID', 3 ,... % =eNBId *256 + local cell Id. 
 ... % 'CELL_ACCMIN', 4 ,...% 'qRxLevMin' in cell data ??? need to remove from code
 'CELL_DL_CHANNEL_BANDWIDTH', 5 ,... %0 for OMNI and 1 for SECTOR and -1 for indoor
 'CELL_BSPWR', 6 ,... % Corresponds 'C-RS transmission power in allowedMeasBandwidth(default is 6RB)', default is 25.8dBm
 'CELL_SYS_TYPE', 7 ,... % Not used. 0 for GSM800, 1 for GSM1900, 2 for 3G 800, 3 for 3G 1900
 'CELL_DIR', 8 ,...  % 'beamDirection' in cell data, if cellinfo(CELL_DIR) is absent, set it to 0 and set CELL_BEAMWIDTH_H=360.
 'CELL_UARFCNDL', 9, ... % UARFCN DL, 
 'CELL_HEIGHT', 10 ,... % default 25m
 'CELL_DOWNTILT', 11 ,... % total Tilt of antenna. default 10 degree;  total Tilt= electricalAntennaTilt + iuantAntennaInstalledMechanicalTilt
 'CELL_BEAMWIDTH_H', 12 ,... % sector 3dB width, default 65 degree, new element in cell data for ECID
 'CELL_BEAMWIDTH_V', 13 ,... % default 15 degree
 'CELL_PHYSICAL_CELLID', 14, ... % cell physical cell ID, physical cellId = 3 x physicalLayerCellIdGroup + physicalLayerSubCellId. 
 'CELL_ENU_EAST',15, ...
 'CELL_ENU_NORTH',16, ...
 'CELL_CORR_FLAG',17, ...       % 0: NOT RELIABLE; 0XFF: RELIABLE. 
 'CELL_cosite_number', 20,...
 'CELL_1',            21,...
 'CELL_2',            22,...
 'CELL_3',            23,...
 'CELL_4',24 ...
 );


global sector_omni_thresh;
sector_omni_thresh = 180; % degree, assume omni cell if beamwidth*2 is greater than this threshold, hidden parameter

INDEX_COL=1;
SC_COL=2;
TA_COL=3;
SS_COL=[4 6 8 10 12 14 16];
NB_COL=[5 7 9 11 13 15];
LONG_COL=17;
LAT_COL=18;

ALT_COL=19;
TS_COL=20;
SIM_COL=21;

% Ellipse
CENTER_LAT_COL=1;
CENTER_LONG_COL=2;
SEMIMAJOR_COL=3;
SEMIMINOR_COL=4;
ORIENTATION_COL=5;
CONFIDENCE_COL=6;

% Cell information
CELL_LAT=1;
CELL_LONG=2;
CELL_ID=3;
CELL_ACCMIN=4;
CELL_ANTENNA_TYPE=5; %0 for OMNI and 1 for SECTOR 
CELL_BSPWR=6;    %BCCH maximum transmit power
CELL_SYS_TYPE=7; %0 for GSM800 and 1 for GSM1900. GSM1900: uplink,1850~1910MHZ; downlink1930~1990MHZ
CELL_DIR=8;             % cell direction. longitude to artic ploc is 0 degree.
CELL_SECTOR_ANGLE=9;