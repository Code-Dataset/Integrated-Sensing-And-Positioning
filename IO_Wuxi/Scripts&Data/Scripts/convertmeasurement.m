function y  =   convertmeasurement(aa, cell)

freqtable=[ 350,2145;
            375,2147.5;
            400,2150;
            425,2152.5;
            450,2155;
            500,2160;
            525,2162.5;
            1527,1837.7;
            1600,1845;
            1650,1850;
            1775,1862.5;
            1300,1815;
            3000,2645;
            3150,2660;
            3562,936.2;
            6300,806];

ImportedDataFormat;

CELLID_COL_bb       =   [SC_COL, NB_COL];
CELLID_COL_aa       =   6:4:30;
SS_COL_bb           =   SS_COL;
SS_COL_aa           =   8:4:32;

bb                  =   NaN(size(aa,1),30);
bb(:,INDEX_COL)     =   1;
bb(:,TA_COL)        =   aa(:,5);

for ii=1:size(aa,1)
    for jj=1:length(CELLID_COL_aa)
        if aa(ii,CELLID_COL_aa(jj))~=-1 && ~isnan(aa(ii,CELLID_COL_aa(jj)))
            bb(ii,CELLID_COL_bb(jj))    =   aa(ii,CELLID_COL_aa(jj)) + aa(ii,CELLID_COL_aa(jj)+1) * 512;
        else
            bb(ii,CELLID_COL_bb(jj))    =   -1;
        end
        bb(ii,SS_COL_bb(jj))    =   aa(ii,SS_COL_aa(jj));
    end
end

bb(:,LONG_COL)      =   aa(:,3);
bb(:,LAT_COL)       =   aa(:,2);


bb(:,ALT_COL)       =   aa(:,34);
bb(:,TS_COL)        =   aa(:,1);

for ii=21:27
    bb(:,ii)        =   aa(:,4*ii-75);
end

if nargin   ==  1 % without celldata
    bb(:,28)    =   -1;
    for ii=1:size(aa,1)
        bb(ii,29)=freqtable(freqtable(:,1)==aa(ii,7),2);
    end
else % with celldata
    [bb,err,sc_error] = MapPciEarfcn2Cid(bb, cell, 0);
    for ii=1:size(aa,1)
        uu=find(cell(:,3)==bb(ii,2));
        hhh=find(freqtable(:,1)==cell(uu(1),15));
        bb(ii,29)=freqtable(hhh,2);
        bb(ii,28)=cell(uu(1),19);
    end
end

bb(:,30)    =   aa(:,35);
y = bb;

end