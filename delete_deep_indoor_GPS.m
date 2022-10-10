% 对已分类的test_req_I进行操作，去掉无GPS的室内数据 deep_indoor
A = [-1];
for i = 1:length(A(:,1))
    test_req_I(test_req_I(:,17)==A(i,1),:) = []
end
test_req_MI = test_req_I;

% test_req_DI = setdiff(test_req_I,test_req_MI,'rows','stable');