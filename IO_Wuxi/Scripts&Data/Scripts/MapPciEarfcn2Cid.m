% mapType
% 0: SC: PCI+EARFCN, NB: PCI+EARFCN
% 1: SC: CID, NB: PCI (intra-freq)

function [measurement,err,sc_error]=MapPciEarfcn2Cid(measurement, cellInfo, mapType)
ImportedDataFormat;
err=[];
sc_error=-ones(size(measurement,1),7);
if nargin==2
    mapType=0; % SC: PCI+EARFCN, NB: PCI+EARFCN
end

pciEarfcn=cellInfo(:,CELL_SC)+cellInfo(:,CELL_UARFCN)*512;
msr_sc=measurement(:,SC_COL);
msr_nb=measurement(:,NB_COL);
msr_nb_ss=measurement(:,SS_COL(1,2:7));
msr_loc=measurement(:,[LAT_COL LONG_COL]);

cellID=cellInfo(:,CELL_ID);
earfcn=cellInfo(:,CELL_UARFCN);

ref=mean(cellInfo(:,[CELL_LAT CELL_LON]));
cellET=convertlatlong2enu(cellInfo(:,[CELL_LAT CELL_LON])*pi/180, ref*pi/180);
msr_ET=convertlatlong2enu(msr_loc*pi/180, ref*pi/180);
cellRadius=cellInfo(:,CELL_RADIUS);
if mapType==0
    msr_id=[msr_sc msr_nb];
    id_num=7;
elseif mapType==1    
    msr_id=msr_nb;
    id_num=6;
end

matlabpool open local 4;
parfor i=1:size(measurement,1)
    msr_id_tmp=msr_id(i,:);
    if mapType==1
        tt=cellID==msr_sc(i);
        if sum(tt)==1
            d=sqrt((cellET(tt,1)-msr_ET(i,1))^2+(cellET(tt,2)-msr_ET(i,2))^2);
            if d < cellRadius(tt)
                msr_id_tmp(1,:)=msr_id_tmp(1,:)+earfcn(tt)*512;
            else
                msr_sc(i)=-1; % Invalidate the measurement
            end
        else
            msr_sc(i)=-1; % Invalidate the measurement
        end
    end
        
    notFound=0;
    for j=1:id_num
        id=msr_id_tmp(1,j);
        if isnan(id) || id==-1
            break
        else
            tt=pciEarfcn==id;
            if sum(tt)==1
                msr_id_tmp(1,j)=cellID(tt);
            elseif sum(tt)==0
                %err=[err;[measurement(i,j)-earfcn*512 earfcn]];
                msr_id_tmp(1,j)=-1;
                notFound=notFound+1;
                sc_error(i,j)=id;
            elseif sum(tt)>1
                %celET=cellET(tt,:);
                %cel=cellInfo(tt,:);
                celId=cellID(tt,:);
                celET=cellET(tt,:);
                [d1 d2]=min((celET(:,1)-msr_ET(i,1)).^2+(celET(:,2)-msr_ET(i,2)).^2);
                msr_id_tmp(1,j)=celId(d2);
            end
        end
    end
    if notFound>0
        if mapType==0
            %msr_nb_id=msr_id_tmp(1,2:end);
            [msr_id_tmp(1,2:end) msr_nb_ss(i,:)]=RemoveNotFoundCell(msr_id_tmp(1,2:end), msr_nb_ss(i,:));
        else
            [msr_id_tmp(1,:) msr_nb_ss(i,:)]=RemoveNotFoundCell(msr_id_tmp(1,:), msr_nb_ss(i,:));
        end        
    end
    msr_id(i,:)=msr_id_tmp;
end

matlabpool close;

if mapType==0
    measurement(:,[SC_COL NB_COL])=msr_id;
elseif mapType==1    
    measurement(:,NB_COL)=msr_id;
end
measurement(:,SS_COL(2:7))=msr_nb_ss;
% measurement(:,SC_COL)=msr_sc;

tt=measurement(:,SC_COL)==-1;
measurement(tt,:)=[];

for ii=1:size(measurement,1)
    for jj=1:size(measurement,2)
        if isnan(measurement(ii,jj))
            measurement(ii,jj)=-1;
        end
    end
end
    
function [cellid_new ss_new]=RemoveNotFoundCell(cellid,ss)
cellid_new=-ones(1,length(cellid));
ss_new=-ones(1,length(cellid));
tt=cellid(1,:)~=-1;
cellid_new(1,1:sum(tt))=cellid(1,tt);
ss_new(1,1:sum(tt))=ss(1,tt);