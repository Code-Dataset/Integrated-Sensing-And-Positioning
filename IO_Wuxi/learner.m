% classifier learner
% Data Preparing
celldatatrain  = celldata_Wuxi_LTE;
celldatatest  = celldata_Yokohama;
% train_data_in = {Indoor_BigCamera,Indoor_Daiei,Indoor_Sheraton,Indoor_Vivre,Indoor_YodobashiCamera};
train_dataset2 = {IndoorMovingGrandOrientalB, IndoorSunningPlazaMix, IndoorMovingYunfu,...
    YunfuIndoorStationary,YunfuIndF123};
train_data_in = [];
for i = 1:length(train_dataset2)
    train_temp = cell2mat(train_dataset2(i));
    p = randperm(size(train_temp,1),round(size(train_temp,1)/5));% randomly sampling
    train_data_in = [train_data_in;train_temp(p,:)];
end
train_dataset1 = {FamilyMart,NanjingBank,HotelLobby,Hotel18thFloor,DadiCinimaRoom7};
train_data_mildin = [];
for j = 1:length(train_dataset1)
    train_temp = cell2mat(train_dataset1(j));
    p = randperm(size(train_temp,1),round(size(train_temp,1)/5));% randomly sampling
    train_data_mildin = [train_data_mildin;train_temp(p,:)];
end
% outdoor_dataset = [Yunfu2HotelWalk;SanyangPlaza;OutdoorSanyangPlaza;OutdoorStationary;OutdoorMoving];
p = randperm(size(urban,1),size([train_data_in;train_data_mildin],1)*2);
train_data_out = urban(p,:);
% Data Labelling
train_data_in = data_lab_test(train_data_in, celldatatrain);
train_data_mildin = data_lab_test(train_data_mildin, celldatatrain);
train_data_out = data_lab_test(train_data_out, celldatatrain);
species_in = 2*ones(length(train_data_in),1); %'indoor is set as 1
species_mildin = ones(length(train_data_mildin),1);
species_out = zeros(length(train_data_out),1); %'outdoor' is set as 0
TrainData = [[train_data_in,species_in];[train_data_mildin,species_mildin];[train_data_out,species_out]];
% 
% TrainData_New = [];
% for i = 1:size(TrainData,1)
%     temp = TrainData(i,:);
%     temp(temp==-1)=nan;
%     TrainData_New(i,:)=temp;
% end
testdataset = {Indoor_BigCamera, Indoor_Daiei, Indoor_Sheraton,Indoor_Vivre,Indoor_YodobashiCamera,Outdoor_1,Outdoor_2};
for j = 1:length(testdataset)
    TestData = data_lab_test(cell2mat(testdataset(j)),celldatatest);
    yfit = trainedModel.predictFcn(TestData);
    tabulate(yfit)
end
 