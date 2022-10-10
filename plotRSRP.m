x=[1:1:600];
semilogy(x,Measurement(1:600,4),'ro');hold on;
semilogy(x,Measurement(1:600,6),'ys');hold on;
semilogy(x,Measurement(1:600,8),'gx');hold on;
semilogy(x,Measurement(1:600,10),'b^');
legend('Serv_RSRP','NB1_RSRP','NB2_RSRP','NB3_RSRP');
xlabel('x');ylabel('RSRP(dBm)');
title('RSRP distribution of the serving cell and its neighboring cells');