% 从数据库中随机采样作为定位请求
% new_test_dataset = setdiff(test_dataset,test_req,'rows','stable')
% new_test_dataset_res_deleteindoor_deleteres = setdiff(test_dataset_res_deleteindoor_deleteres,test_req,'rows','stable')
% 通过集合做差方式，去除已经抽取的元素 （不同）
test_dataset = {MovingHotelLobby,NanjingBank,StationaryHotelF18,StationaryHotelLobby,YunfuIndF123,YunfuIndF35,YunfuIndF4,YunfuIndF6,YunfuIndF7,YunfuIndoorStationary,SanyangPlaza,Station2HotelOutdoor,StationayOut,Yunfu2HotelWalk,YunfuOut};
test_req = [];
for i = 1:length(test_dataset)
    temp = cell2mat(test_dataset(i));                    % 转换元胞数组为数值数组
    p = randperm(size(temp,1),round(size(temp,1)/4));    % randomly sampling（按比例）
    test_req = [test_req;temp(p,:)];
end