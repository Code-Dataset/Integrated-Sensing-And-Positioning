
testdata = IndoorSunningPlazaStationary;
D = [];
figure;
for i = 1: size(testdata,1)
    reqdata = testdata(i,:);
    plot(reqdata(1,17),reqdata(1,18),'sb'); hold on
    IDs = [2,5,7,9,11,13,15];
    for j = 1:length(IDs)
        refdata = celldata_Wuxi_LTE(celldata_Wuxi_LTE(:,3) == testdata(i,IDs(j)),:);      
        if ~isnan(refdata)
            refdata = refdata(1,:);
            X = [reqdata(1,17),reqdata(1,18)]*pi/180;
            R = [refdata(2),refdata(1)]*pi/180;
        d   =   convertlatlong2enu(X,R);
        dd(j)   =   sqrt(d(1)^2+d(2)^2); 
            plot(refdata(2),refdata(1),'^r'); hold on       
        else
        dd(j)   =   NaN;
        end
    end
    disp(dd)
    D   =   [D;dd];
end
plot_google_map
    