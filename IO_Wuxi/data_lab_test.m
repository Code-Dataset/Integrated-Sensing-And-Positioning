 % m: measurement
% celldata: for each cell reported in m, in order
% function for data cleaning and labeling with rules.
% Created by Leonardo Zhang ----- 2017/11/24 -----
%%
function labels = data_lab_test(meas, celldata)
ImportedDataFormat;    
labels_tmp = [];
    for i  =  1:size(meas,1)
        m                       =       meas(i,:);  
        %% F1: check the serving cell: indoor -> 1; outdoor ->0. 
        SC_ID                  =       m(1,SC_COL);
        Servingcell            =       celldata(celldata (:,3) == SC_ID,:);
        label_1                =       Servingcell(1,18);
        %% F2: Collect the num of Neighbor Measurements;
        NB_IDs                  =       m(1,NB_COL);%
        NB_IDs                  =       NB_IDs(NB_IDs  ~= -1);
        label_2                 =       size(NB_IDs,1); 
        %% F3: Check the num of Indoor cells in the NM
        label_3 = 0;
        if ~isnan(NB_IDs(:))
            celldata_m          =       [];
            for j   =   1:length(NB_IDs)
                temp            =       celldata(celldata(:,3)==NB_IDs(j),:);
                celldata_m      =       [celldata_m;temp(1,:)];
            end
                label_3 = size(find(celldata_m(:,CELL_INDOOR) == 1),1);

        %% F4: Delta RSRP & RSRQ
        rsrp                    =       m(1,NB_RSRP);
        rsrq                    =       m(1,NB_RSRQ);
        label_4                 =       NaN;
        label_5                 =       NaN;
            if label_1 == 1
                ind_nb              =       find(celldata_m(:,CELL_INDOOR) == 0);
            else    
                ind_nb              =       find(celldata_m(:,CELL_INDOOR) == 1);
            end
            if ~isnan(ind_nb)
                rsrp                =       rsrp(ind_nb);
                rsrp                =       rsrp(rsrp ~= -1); 
                [nbs_RSRP,index]    =       max(rsrp);

                rsrq                =       rsrq(ind_nb);
                rsrq                =       rsrq(rsrq ~= -1);
                nbs_RSRQ            =       rsrq(index);        

                sc_RSRP             =       m(1,SS_COL(1));
                sc_RSRQ             =       m(1,SS_RSRQ(1));

                delta_rsrp          =      sc_RSRP-nbs_RSRP;
                delta_rsrq          =      sc_RSRQ-nbs_RSRQ;
%                 eks = delta_rsrp + 1.5*delta_rsrq;
%                 if  label_1 == 1 && eks >= 0
%                     label_4 = 1-0.5*exp((-eks^2)/(2*5^2));
%                 elseif label_1 == 1 && eks < 0
%                     label_4 = 0.5*exp((-eks^2)/(2*5^2));
%                 elseif label_1 == 0 && eks >= 0
%                     label_4 = 0.5*exp((-eks^2)/(2*5^2));
%                 else
%                     label_4 = 1-0.5*exp((-eks^2)/(2*5^2));
%                 end
                  label_4             =       delta_rsrp;
                  label_5             =       delta_rsrq;
%             else
% %                 eks = NaN;
%                   label_4             =       NaN;
%                   label_5             =       NaN;
            end
        end        
         %% F5 Hata Channel Model
            cc                          =           8;
            rstp                        =           m(1,RSTP);
            ta                          =           m(1,TA_COL);
                if ta == -1
                    ta = 0;
                end
            distance = (ta+0.5)*78;
            freq                        =           m(1,DL_FREQ);
            EstimatedRSRP               =           30 + 10 * log10(rstp) - (46.3 + 33.9 * log10(freq)+ 44.9 * log10(distance/1000) + 3);
            ServingRSRP                 =           m(1,SS_COL(1));
            delta_x                     =           EstimatedRSRP - ServingRSRP;
            label_6        =           delta_x;
%             label_6        =           0;
%             if  ~isnan(delta_x)
%                 if delta_x >= 0
%                     label_6        =           1 - exp(-delta_x^2 / (2*cc^2));
%                 else
%                     label_6        =           exp(-delta_x^2 / (2*cc^2));    
%                 end
%             end
%          else
%             delta_x        =           NaN;
%             label_6        =           1;
%          end
            labels_tmp             =       [labels_tmp;m(1,SS_COL(1)), m(1,SS_RSRQ(1)),m(1,NB_RSRP),m(1,NB_RSRQ),label_1,label_2,label_3,label_4,label_5,label_6];
    %         labels_tmp             =       [delta_x,sc_RSRP,nbs_RSRP,sc_RSRQ,nbs_RSRQ];

    end
            %%
        labels = labels_tmp;
end
