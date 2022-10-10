% 判断数据库数据有无GPS
A = [-1];
for i = 1:length(A(:,1))
    test(test(:,17)==A(i,1),:) = []
end
test_GPS = test;

% test_xGPS = setdiff(test,test_GPS,'rows','stable');