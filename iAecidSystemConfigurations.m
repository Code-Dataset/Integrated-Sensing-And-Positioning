% iAecid system configurations
 % 0 means GSM, 1 means WCDMA, 2 means LTE
 SystemConfigureOption  =2;   
 
 % 0 means off, 1 means on;
 TARTTTurnOnOff  = 0; 
 

% Max neighbor cell calculated
MaxNeighborCellCalculated=6;


TsDistance = 9.7656;  % 1Ts is about 9.7656meter  TS = 1/(2048*1500). 乘以光�??
% weight when serving cell and neighbour cell 1 position is matched
SC_OrderWeight=0.8;

% 
MaxClusterSize=65535;

%
%InvolveCositeThreshold=0.6;
%verysimilar=4;

% grid size for generate grid map
gridmap_step=6;

% Confidence schema
S_95=5.01;
S_90=4.62;
S_85=4.23;
S_80=3.84;
S_75=3.46;
S_70=3.07;
S_65=2.68;


% when simimarity of reference measurements and request measurement is less than MaxSimilarityThreshold2, it's similar measurement. otherwise, not
MaxSimilarityThreshold2=8;

% max number of similar measurements.
% when more than or equal to MaxNumSimilarPointsThreshold similar reference measurements are found, stop finding similar measurements
% MaxNumSimilarPointsThreshold=8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MaxNumSimilarPointsThreshold=8;


% max pathloss/signal strength difference  between serving cell and possible
% not detected; unit: dB
MaxPathDiffForDect = 20; 

%the amount of punishment when not enough same cells are found in the reference
%measurement when calculate the similarity
PunishForInSufficientMapingCells = 2;

%minimum semiMajor and semiMinor, default 15meter.
minSemiMajor=15; 
minSemMinor=15; 

% minimum number of similar measurements for positioning,
% when less than it, positioning is failed.
minNumOfSimilarMeas = 1; 

% when only 1 similar measurement is found, can't generate Ellipse.
% circle is generated instead. assume the radius of circle is 100m as
% default
estimatedCircleRadius = 100;


ConfidenceSchema_sim = [
    S_95 0.95;
    S_90 0.90;
    S_85 0.85;
    S_80 0.80;
    S_75 0.75;
    S_70 0.70;
    S_65 0.65;
    %MinSimilarityThreshold 0.60;
    ];

ConfidenceSchema_num = [
    500 0.95;
    240 0.90;
    120 0.85;
    60 0.80;
    30 0.75;
    MaxNumSimilarPointsThreshold 0.70;
    1                            0.30;
    ];



 

TaLUT= [
 0  0	    1311  0.004	0.002;
 1  0	    1600  0.004	0.002;
 2  0	    2086  0.004	0.002;
 3  0	    2521  0.004	0.002;
 4  600	    3300  0.004	0.002;
 5  1000	5500  0.004	0.002;
 6  1200	6600  0.004	0.002;
 7  1564	6700  0.004	0.002;
 8  1564	6911  0.002	0.001;
 9  3002	7000  0.002	0.001;
10  4100	7100  0.002	0.001;
11  4501	7240  0.002	0.001;
12  4577	7748  0.001	0.0005;
13  4577	8450  0.001	0.0005;
14  4577	9034  0.001	0.0005;
15  4577	9459  0.001	0.0005;
16  4577	12000  0.001	0.0005;
17  4577	13000  0.0008	0.0004;
18  4577	14535  0.0008	0.0004;
19  5000	14535  0.0008	0.0004;
20  5500	14843  0.0008	0.0004;
21  6000	14843  0.0008	0.0004;
22  8266	14843  0.0004	0.0002;
23  8321	14843  0.0004	0.0002;
24  8500	14843  0.0004	0.0002;
25  8600	15149  0.0004	0.0002;
26  8700	15615  0.0002	0.0001;
27  8800	15844  0.0002	0.0001;
28  9000	16116  0.0002	0.0001;
29  9100	16981  0.0002	0.0001;
30  9295	17736  0.0002	0.0001;
31  9400	18012  0.0002	0.0001;
32  9629	18681  0.0002	0.0001;
33  11000	19133  0.0002	0.0001;
34  12318	19676  0.0002	0.0001;
35  13000	20535  0.0002	0.0001;
36  14000	21087  0.0002	0.0001;
37  14500	21109  0.0002	0.0001;
38  15136	21820  0.0002	0.0001;
39  16000	22031  0.0002	0.0001;
40  17000	22837  0.0002	0.0001;
41  18000	23533  0.0002	0.0001;
42  19000	23533  0.0002	0.0001;
43  20000	24844  0.0002	0.0001;
44  21000	24880  0.0002	0.0001;
45  22000	25623  0.0002	0.0001;
46  23011	26013  0.0002	0.0001;
47  23011	26013  0.0002	0.0001;
48  24000	27793  0.0002	0.0001;
49  24500	27848  0.0002	0.0001;
50  25000	28583  0.0002	0.0001;
51  25500	29125  0.0002	0.0001;
52  25500	30104  0.0002	0.0001;
53  27000	30290  0.0002	0.0001;
54  27500	30357  0.0002	0.0001;
55  28000	30858  0.0002	0.0001;
56  28500	31699  0.0002	0.0001;
57  29000	33000  0.0002	0.0001;
58  29500	34500  0.0002	0.0001;
59  30000	33000  0.0002	0.0001;
60  31000	33268  0.0002	0.0001;
61  32000	34000  0.0002	0.0001;
62  33000	37000  0.0002	0.0001;
63  34000	38000  0.0002	0.0001;                           
];

RTTUpbound = 100;
RTTDownBound = -200;
RTTUpCoe = 0.02;
RTTDownCoe = 0.04;



% RTT Quantization Schema
RTTQuantizationSchema = [ %Column 1: Quantized_Val
    0 0 100;        %Column 2: Start_Val
    1 101 200;      %Column 3: End_Val
    2 201 300;
    3 301 450;
    4 451 650;
    5 651 850;
    6 851 1100;
    7 1101 1400;
    8 1401 1700;
    9 1701 2000;
    10 2001 2300;
    11 2301 2645;
    12 2646 3041;
    13 3042 3498;
    14 3499 4022;
    15 4023 4626;
    16 4627 5320;
    17 5321 6118;
    18 6119 7035;
    19 7036 8091;
    20 8092 9304;
    21 9305 10700;
    22 10701 12305;
    23 12306 14151;
    24 14152 16274;
    25 16275 18715;
    26 18716 21522;
    27 21523 24750;
    28 24751 28463;
    29 28464 32733;
    30 32734 37643;
    31 37644 43289;
    32 43290 49782;
    33 49783 57250;
    34 57251 65837;
    35 65838 75713;
    36 75714 87070;
    37 87071 100131;
    38 100132 115150;
    39 115151 132423;
    40 132424 152286;
    41 152287 175130;
    42 175131 201399;
    43 201400 231609;
    44 231610 255527
    ];

% LTE timing advance Quantization Schema 
% this look-up-table is only for UE RX-TX timing difference. 
% 16Ts *9.7656 = 156m
% 16Ts *9.7656/2 = 78m.
% 1st column: 0 means 0*16Ts
%             1 means 1 *16Ts
%             2 means 2* 16Ts
% timing advance: measured via PRACH, and send to UE to adjust
% TA=0在算法里面当成是均�?�为85米，高斯方差�?35米的范围（已经被换算成单程距离）
LTETAQuantizationSchema = [ %Column 1: TA value    
    0  85    35;         %Column 2: mean value                 
    1  110   60;       %Column 3: Gaussian distr.    ?m @1s
    2  160   65;                                           
    3  215   70;                                           
    4  281   75;                                           
    5  360   90;                                           
    6  440   100;                                         
    7  500   120;                                        
    8  580   140;                                        
    9  660   160;      
    10 740   180;
    11 820   200;
    12 900   200;
    13 980   200;
    14 1060  200;
    15 1140  200;
    16 1220  200;
    17 1300  200;
    18 1380  200;
    19 1460  200;
    20 1540  200
    ];

% the TA unit is 16Ts, which is about 156m; because of come and forth,
% it's 78m. 
LTETA2DistanceUnit = 78;
% because of refraction, correction is needed.
LTETACorrectionValue = -30;
%Gaussian deviation, default is 200m.
LTETADeviation = 200;

