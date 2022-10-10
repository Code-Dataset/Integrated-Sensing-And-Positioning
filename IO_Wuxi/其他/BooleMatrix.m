function [ B ] = BooleMatrix(A) %把数据转化为布尔矩阵（元素只取0或1的矩阵，故又称0-1矩阵），注意读入的数据一定是每行数据的个数一致
M = size(A,1);                  %A的行数
N = size(A,2);                  %A的列数
B = zeros(M,N);
for i = 1:M
    for j = 1:N
        B(i,A(i,j)) = 1;
    end 
end
end
