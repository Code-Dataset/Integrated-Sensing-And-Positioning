ImportedDataFormat;
% HODATA = [urban;HSRonBoard]; 
HODATA = HSRonBoard(330:end,:); 
SS = HODATA(:,SS_COL);RSRQ = HODATA(:,SS_RSRQ);TIME = HODATA(:,20)-HODATA(1,20);
SS(find(SS==-1)) =nan;RSRQ(find(RSRQ==-1)) =nan;
c1 = SS(:,1); c2 = SS(:,2);c3 = SS(:,1)-SS(:,2);c4 = RSRQ(:,1)- RSRQ(:,2);
figure;
scatter(HODATA(:,17),HODATA(:,18),[],c1);hold on
index = find(c3<= -3);index4 = find(c4 <= -3);
plot(HODATA(index,17),HODATA(index,18),'xr'); hold on

V = [];
for i = 1:size(HODATA,1)
D = [HODATA(:,[17,18,20]);HODATA(end,[17,18,20])];
time = D(i+1,3) -D(i,3);
d1 = [D(i+1,1),D(i+1,2)]*pi/180;
d2 = [D(i,1),D(i,2)]*pi/180;
        d   =   convertlatlong2enu(d1,d2);
        dd   =   sqrt(d(1)^2+d(2)^2);
        v  = dd/time;
scid = HODATA(i,2);
ncid = HODATA(i,5);
hodata = [scid,SS(i,1),RSRQ(i,1),ncid,SS(i,2),RSRQ(i,2)];
if ncid == -1
    d2n = nan;
else
index2 = find(celldata_Wuxi_LTE(:,3) == scid);
index3 = find(celldata_Wuxi_LTE(:,3) == ncid);
index2 = index2(1);index3 = index3(1);
latlon = [celldata_Wuxi_LTE(index2,2),celldata_Wuxi_LTE(index2,1)];
latlon2 = [celldata_Wuxi_LTE(index3,2),celldata_Wuxi_LTE(index3,1)];
% LATLON = [LATLON;[scid,latlon]];
d3 = latlon*pi/180;
d4 = latlon2*pi/180;
ds = convertlatlong2enu(d2,d3);
dn = convertlatlong2enu(d2,d4);
d2s =  sqrt(ds(1)^2+ds(2)^2);
d2n =  sqrt(dn(1)^2+dn(2)^2);
end
V = [V;v,time,dd,d2s,d2n,hodata];
end

temp = unique(V(:,6));
P = {};
n = [];
celldata_S=[];
PL_sum = [];
% figure;
for j = 1:length(temp)    
    celldata_s = celldata_Wuxi_LTE(celldata_Wuxi_LTE(:,3) == temp(j),:);
    plot(celldata_s(:,2),celldata_s(:,1),'^','LineWidth',4); hold on   
    celldata_S = [celldata_S;celldata_s(1,:)];
    index5 = find(V(:,6) == temp(j));
    P_temp = V(index5,:);
    ddd = 10*log10(P_temp(:,4));
    pl = 80 - P_temp(:,7);%celldata_s(1,19)
    p0 = polyfit(ddd,pl,1);
    n = [n,p0(1)];
%     plot(ddd, polyval(p0,ddd)); hold on
%     plot(ddd, pl,'^');hold on
    PL_sum = [PL_sum;ddd,pl];
    P{j} = [P_temp,ddd,pl];
end
% plot(celldata_S(:,2),celldata_S(:,1),'gs');
% plot_google_map

figure;
speed = V(:,1)*3.6;
plot(speed)
hold on
plot(index,speed(index),'rx')
hold on
plot(index4,speed(index4),'gs')
plot(smooth(speed,100))
