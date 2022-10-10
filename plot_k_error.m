x = [1 2 4 6 8 10];  %3
y67 = [0.1614 1.1432 2.8838 3.9639 4.7392 5.3677];% 2.2134
yy67 = [0.1497 1.0814 2.7832 3.8467 4.5688 5.2574];%2.1242 
y90 = [7.0354 12.7360 16.3998 17.7423 19.2860 19.9968];% 15.4519
yy90 = [6.9135 12.5644 16.2220  17.3537 18.9559 19.8347];% 15.2801

plot(x,y67,'r--','Linewidth',1);
for i=1:6
text(x(i),y67(i),['(',num2str(x(i)),',',num2str(y67(i)),')']);
end
hold on;
plot(x,yy67,'b--','Linewidth',1);
for i=1:6
text(x(i),yy67(i),['(',num2str(x(i)),',',num2str(yy67(i)),')']);
end
hold on;
plot(x,y90,'r-','Linewidth',1);
for i=1:6
text(x(i),y90(i),['(',num2str(x(i)),',',num2str(y90(i)),')']);
end
hold on;
plot(x,yy90,'b-','Linewidth',1);
for i=1:6
text(x(i),yy90(i),['(',num2str(x(i)),',',num2str(yy90(i)),')']);
end
legend('67%error (Before IO Classification)','67%error (After IO Classification)','90%error (Before IO Classification)','90%error (After IO Classification)');
xlabel('K value');ylabel('Positioning error(m)');
title('Positioning error under different K values');