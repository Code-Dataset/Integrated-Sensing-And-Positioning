% Generate ellipse from points
% Get ellipse from a bunch of points in ENU
%
% Input: pointsET: points in ENU 西北天坐标系
%        confidence: confidence
%        refPoint: reference points, [lat long] in rad  经纬坐标系弧度
%
% Output: ellipse: [center_lat(rad) center_long(rad) semiMajor semiMinor Orientation_Angle report_confidence]  生成一个椭圆，返回椭圆中心点，长短轴，旋转角，conf

% 根据路测中的相似测量报告生成椭圆，用的是WKNN算法。
% 将前面算出的相似度求倒数然后归一化，求出weight。然后根据权重生成之后的位置，椭圆中心。
% 然后求出候选MSR和椭圆中心的差值矩阵m，求出这个矩阵的协方差矩阵。对协方差矩阵求特征值然后做个数学变换，就是最后的长短轴
function theEllipsePoints=generateEllipseFromEigVector2(pointsET, confidence, refPoint)
ImportedDataFormat;
iAecidSystemConfigurations;

% Weighted K Nearest Neighbor(WKNN) algorithm, obtain the weight of each reference fingerprint.
% 更新similarMeasurementsET中的相似度。用（1/每条记录的相似度）/所有记录相似度的倒数和代替。
recipWeight = 1./pointsET(:,3);
totalWeight = sum(recipWeight);
pointsET(:,3) = recipWeight./totalWeight;   % 归一化权值

% Calculate center of the ellipse 计算椭圆的中心点，就是用每个候选MSR的位置乘以权重，得出最后的位置
center=[sum(pointsET(:,1).*pointsET(:,3)) sum(pointsET(:,2).*pointsET(:,3))];

% 计算特征向量和特征值
[v d] = eigvector(pointsET, confidence, center);

% 用2个特征值中间较大的那个作为椭圆的长轴，较小的那个作为短轴。椭圆的旋转角度是90度-特征向量之比。
if abs(d(1,1))>=abs(d(2,2))
    semiMajor = abs(d(1,1));
    semiMinor = abs(d(2,2));
    orientationAngle = atan(v(2,1)/v(1,1));
else
    semiMajor = abs(d(2,2));
    semiMinor = abs(d(1,1));
    orientationAngle = atan(v(2,2)/v(1,2));
end

orientationAngle = pi/2-orientationAngle;

% minimum semiMajor and semiMinor, default 15meter.
if semiMajor<minSemiMajor
   semiMajor = minSemiMajor;       % 对长短轴做保护，如果小于15当15用
end

if semiMinor<minSemMinor
   semiMinor = minSemMinor;
end

% 将中心点ENU转换回ECEF地心坐标系，然后输出椭圆中心点，长短轴，旋转角度，conf。
center=convertenu2latlong(center, refPoint);
theEllipsePoints(1,CENTER_LAT_COL) = center(1,1);   % 中心点的经纬度
theEllipsePoints(1,CENTER_LONG_COL) = center(1,2);
theEllipsePoints(1,SEMIMAJOR_COL) = semiMajor;      % 长短轴
theEllipsePoints(1,SEMIMINOR_COL) = semiMinor;
theEllipsePoints(1,ORIENTATION_COL) = orientationAngle;
theEllipsePoints(1,CONFIDENCE_COL) = confidence;
