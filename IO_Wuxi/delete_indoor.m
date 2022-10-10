% 对已有标签的test_dataset_res进行操作，去掉分类后的室内数据 indoor为‘1’==49
A = [49];
% for i = 1:length(A(:,1))
   % test_dataset_res(test_dataset_res(:,30)==A(i,1),:) = []
%end
for i = 1:length(A(:,1))
    test_req_res(test_req_res(:,30)==A(i,1),:) = []
end