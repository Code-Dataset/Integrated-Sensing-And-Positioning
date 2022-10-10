clear,close;clc;
 load('WuxiData.mat');
%  load('YokohamaData.mat');
%  load('treebagger.mat');
%  predict(BaggedEnsemble,data_lab_test(FuxingRoadOutdoor,celldata_LTE));tabulate(ans)
%% Trainning
% train_data_in = {Indoor_BigCamera,Indoor_Daiei,Indoor_Sheraton,Indoor_Vivre,Indoor_YodobashiCamera};
% train_data = {FamilyMart, Hotel18thFloor,HotelLobby,IndoorMovingGrandOrientalAF12345, ...
%     IndoorMovingGrandOrientalB, IndoorSunningPlazaMix, DadiCinimaRoom7,IndoorMovingYunfu,...
%     YunfuIndoorStationary,MovingHotelLobby,NanjingBank,YunfuIndF123};

% train_dataset=[DadiCinimaRoom7;FamilyMart;Hotel18thFloor;HotelLobby;HSRonBoard;HSRStation;IndoorMovingGrandOrientalAF12345;IndoorMovingGrandOrientalB;IndoorMovingYunfu;IndoorSunningPlazaMix;IndoorSunningPlazaStationary;FuxingRoadOutdoor;MovingOut;OutdoorMoving;OutdoorSanyangPlaza;OutdoorStationary];
train_data={DadiCinimaRoom7,FamilyMart,Hotel18thFloor,HotelLobby,HSRonBoard,HSRStation,IndoorMovingGrandOrientalAF12345, IndoorMovingGrandOrientalB, IndoorMovingYunfu, IndoorSunningPlazaMix, IndoorSunningPlazaStationary};
train_data_in = [];
for i = 1:length(train_data)
    train_temp = cell2mat(train_data(i));                            % 转换元胞数组为数值数组
    p = randperm(size(train_temp,1),round(size(train_temp,1)/6));    % randomly sampling
    train_data_in = [train_data_in;train_temp(p,:)];
end
% outdoordata_Yohokama = [Outdoor_1;Outdoor_2];
% train_data_out = outdoordata_Yohokama(p,:);
% outdoor_dataset = [Yunfu2HotelWalk;SanyangPlaza;OutdoorSanyangPlaza;OutdoorStationary;OutdoorMoving];
outdoor_dataset = [FuxingRoadOutdoor;MovingOut;OutdoorMoving;OutdoorSanyangPlaza;OutdoorStationary];
p = randperm(length(urban),length(train_data_in)*4);
train_data_out = urban(p,:);
% species_in = cellstr(repmat('indoor',length(train_data_in),1));      % 复制和平铺矩阵,转换为字符向量元胞数组
% species_out = cellstr(repmat('outdoor',length(train_data_out),1));
species_in = cellstr(repmat('1',length(train_data_in),1));
species_out = cellstr(repmat('0',length(train_data_out),1));
species = [species_in;species_out];
tic;                                                                 % tic表示计时的开始，toc表示计时的结束
meas = data_lab_test([train_data_in; train_data_out], celldata_Wuxi_LTE);
% meas = data_lab_test([train_data_in; train_data_out], celldata_Yokohama);
meas(meas(:,1:8)==-1)=-144;
toc;
tic;
BaggedEnsemble = generic_random_forests(meas,species,100,'classification');
toc;

%% test indoor
% test_indoor = {Indoor_BigCamera,Indoor_Daiei,Indoor_Sheraton,Indoor_Vivre,Indoor_YodobashiCamera};
% test_indoor = {FamilyMart, Hotel18thFloor,HotelLobby,IndoorMovingGrandOrientalAF12345, ...
%     IndoorMovingGrandOrientalB, IndoorSunningPlazaMix, DadiCinimaRoom7,IndoorMovingYunfu,...
%     YunfuIndoorStationary,MovingHotelLobby,NanjingBank,YunfuIndF123};
test_indoor = [MovingHotelLobby;NanjingBank;StationaryHotelF18;StationaryHotelLobby;YunfuIndF123;YunfuIndF35;YunfuIndF4;YunfuIndF6;YunfuIndF7;YunfuIndoorStationary];
% test_dataset=[MovingHotelLobby;NanjingBank;StationaryHotelF18;StationaryHotelLobby;YunfuIndF123;YunfuIndF35;YunfuIndF4;YunfuIndF6;YunfuIndF7;YunfuIndoorStationary;SanyangPlaza;Station2HotelOutdoor;StationayOut;Yunfu2HotelWalk;YunfuOut];
RES = [];
temp = data_lab_test(test_indoor, celldata_Wuxi_LTE);
temp(temp(:,1:8)==-1)=-144;
     parfor i = 1:length(temp)
        res = [temp(i,:),predict(BaggedEnsemble,temp(i,:))];
        RES = [RES;res];
    end
    disp('indoor data prediction:')
    tabulate(RES(:,2));                        % 创建向量X信息数据频率表.结构为：第一列 x的唯一值；第二列 每个值的实例数量；第三列 每个值的百分比
% for k = 1:length(test_indoor) 
%    temp =[];
%    temp = data_lab_test(test_indoor{1,k}, celldata_Yokohama);
%    temp = data_lab_test(test_indoor{1,k}, celldata_Wuxi_LTE);
%    temp(temp(:,1:8)==-1)=-144;
%    RES = [];
%    parfor i = 1:size(temp,1)
%        res =  [temp(i,:),predict(BaggedEnsemble,temp(i,:))];
%        RES = [RES;res];
%    end
%    disp('indoor data prediction:')
%    tabulate(RES(:,2));                               
% end

%% test outdoor
% test_outdoor = [Outdoor_1;Outdoor_2];
test_outdoor = [SanyangPlaza;Station2HotelOutdoor;StationayOut;Yunfu2HotelWalk;YunfuOut];  %一个数值数组
% test_outdoor = {SanyangPlaza,Station2HotelOutdoor,StationayOut,Yunfu2HotelWalk,YunfuOut}; 一个元胞数组
% pp = randperm(length(test_outdoor),length(train_data_out)/2); 采样 八十多
% test_pre = test_outdoor(pp,:);
test_pre = test_outdoor;
RES2 = [];
% temp = data_lab_test(test_pre, celldata_Yokohama);
temp = data_lab_test(test_pre, celldata_Wuxi_LTE);
temp(temp(:,1:8)==-1)=-144;
    parfor i = 1:length(temp)
        res2 = [temp(i,:),predict(BaggedEnsemble,temp(i,:))];
        RES2 = [RES2;res2];
    end
    disp('outdoor data prediction:')%输出字符串
    tabulate(RES2(:,2));%创建信息数据频率表