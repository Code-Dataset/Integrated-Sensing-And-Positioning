% error_cdf_K4\8_1: 分类前1列 / error_cdf_K4\8_2: 分类后1列
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  K=1
n1=0:length(error_cdf_K1_1);
x1=[0;error_cdf_K1_1];
f1=n1/length(error_cdf_K1_1)*100;

nn1=0:length(error_cdf_K1_2);
xx1=[0;error_cdf_K1_2];
ff1=nn1/length(error_cdf_K1_2)*100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  K=2
n2=0:length(error_cdf_K2_1);
x2=[0;error_cdf_K2_1];
f2=n2/length(error_cdf_K2_1)*100;

nn2=0:length(error_cdf_K2_2);
xx2=[0;error_cdf_K2_2];
ff2=nn2/length(error_cdf_K2_2)*100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  K=4
n4=0:length(error_cdf_K4_1);
x4=[0;error_cdf_K4_1];
f4=n4/length(error_cdf_K4_1)*100;

nn4=0:length(error_cdf_K4_2);
xx4=[0;error_cdf_K4_2];
ff4=nn4/length(error_cdf_K4_2)*100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  K=8
n8=0:length(error_cdf_K8_1);
x8=[0;error_cdf_K8_1];
f8=n8/length(error_cdf_K8_1)*100;

nn8=0:length(error_cdf_K8_2);
xx8=[0;error_cdf_K8_2];
ff8=nn8/length(error_cdf_K8_2)*100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  plot
plot(x1,f1,'r--','Linewidth',1);
hold on;
plot(xx1,ff1,'b--','Linewidth',1);
hold on;
plot(x2,f2,'r-.','Linewidth',1);
hold on;
plot(xx2,ff2,'b-.','Linewidth',1);
hold on;
plot(x4,f4,'r:','Linewidth',1);
hold on;
plot(xx4,ff4,'b:','Linewidth',1);
hold on;
plot(x8,f8,'r-','Linewidth',1);
hold on;
plot(xx8,ff8,'b-','Linewidth',1);



legend('K=1 (Before IO Classification)','K=1 (After IO Classification)','K=2 (Before IO Classification)','K=2 (After IO Classification)','K=4 (Before IO Classification)','K=4 (After IO Classification)','K=8 (Before IO Classification)','K=8 (After IO Classification)');
xlabel('2D error(meter)');ylabel('percentage (%)');
title('The CDF under different K values');
