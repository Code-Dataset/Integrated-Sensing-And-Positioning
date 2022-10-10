% Generate eigen value and eigen vector of a bunch of points
% Input: a, N*2 ENU matrix 二维西北天坐标系 每条记录相对于最相似记录的位置
%        pe, confidence
%        center, center of the ellipse in ENU(can be omitted) 椭圆的中心点，就是用每个候选MSR的位置乘以权重，得出最后的位置
%
% Output: v, eigen vector
%         d, eigen value

% 求出候选MSR和椭圆中心的差值矩阵m，求出这个矩阵的协方差矩阵。对协方差矩阵求特征值然后做个数学变换，就是最后的长短轴
function [v d]=eigvector(a, pe, center)

% 如果有椭圆中心点坐标，用中心点坐标作为u，如果没有，就用筛选出来的MSR的均值作为中心点坐标
if nargin == 3
    u = center;
else
    u = mean(a);
end

% 计算m矩阵，值为K条候选MSR坐标和中心点坐标的差
m = [a(:,1)-u(1,1) a(:,2)-u(1,2)];

% 如果没有MSR，那么特征值为1000000
if length(a(:,1)) == 0
    d = 1000000;
% 如果有异常出现，hardcode特征值为10000
else
    if isnan(m'*m/length(a(:,1)))
        d = [1000000 10000;10000 10000];
        v = [ -0.9906   -0.1368;   -0.1368    0.9906];
% 如果无异常，计算MSR的坐标和中心点坐标的差的协方差矩阵的特征值和特征向量
    else
        [v d]=eig(m'*m/length(a(:,1)));
    end    
end
% pause
% 将算出来的特征值再根据confidence进行一次数学变换，得出新特征值
d=sqrt(d*(-2*log(1-pe)));    % 实际上长短轴还是受到conf控制的