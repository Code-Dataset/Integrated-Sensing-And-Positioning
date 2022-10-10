% 只从室外数据中抽取定位请求
test_dataset_outdoor = {SanyangPlaza,Station2HotelOutdoor,StationayOut,Yunfu2HotelWalk,YunfuOut};
test_req4_outdoor = [];
for i = 1:length(test_dataset_outdoor)
    temp = cell2mat(test_dataset_outdoor(i));                    % 转换元胞数组为数值数组
    p = randperm(size(temp,1),round(size(temp,1)/4));    % randomly sampling（按比例）
    test_req4_outdoor = [test_req4_outdoor;temp(p,:)];
end
test_dataset_outdoor = [SanyangPlaza;Station2HotelOutdoor;StationayOut;Yunfu2HotelWalk;YunfuOut];