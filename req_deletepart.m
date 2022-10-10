% test_dataset中含有和test_req相同的部分，从test_req中随机抽取一部分删除，更符合实际情况。

A = test_req;%原数组
[M,N] = size(A); %读取矩阵行列数;
num = round(M*(3/4)); % 取A的1/2行作为训练集，round为四舍五入取整;
[~,idx] = sort(rand(M,1));%随机排列生成index;
req_delete = A(idx(1:num),:);%根据index选取1/2的A集为B集;
% C=A(idx(num+1:M),:);%保存剩余的数据为C集;
new_test_dataset = setdiff(test_dataset,req_delete,'rows','stable')
new_test_dataset_res_deleteindoor_deleteres = setdiff(test_dataset_res_deleteindoor_deleteres,req_delete,'rows','stable')
% 通过集合做差方式，去除已经抽取的元素
