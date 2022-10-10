n=0:length(error_cdf_K8_1);
x=[0;error_cdf_K8_1];
f=n/length(error_cdf_K8_1)*100;

n1=0:length(error_cdf_K8_2);
x1=[0;error_cdf_K8_2];
f1=n1/length(error_cdf_K8_2)*100;

plot(x,f,'r-','Linewidth',1);
hold on;
plot(x1,f1,'b-','Linewidth',1);
legend('Before IO Classification','After IO Classification');
xlabel('2D error(meter)');ylabel('percentage (%)');
title('CDF');