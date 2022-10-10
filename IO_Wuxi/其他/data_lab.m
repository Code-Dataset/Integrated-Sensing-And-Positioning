% m: measurement
% celldata: for each cell reported in m, in order
% function for data cleaning and labeling with rules.
% Created by Leonardo Zhang ----- 2017/11/24 -----
%%
function labels = data_lab(meas, celldata)
ImportedDataFormat;
%% F1: check indoor cells' number.
labels = [];
labels_tmp = [];
    for i  =  1:size(meas,1)
    m                       =       meas(i,:);
    Cells                   =       m(1,[2,NB_COL]);%2: inclue serving cell;
    Cells                   =       Cells(find(Cells ~= -1));
    celldata_m              =       [];
        if ~isnan(Cells)
            for ii   =   1:length(Cells)
                temp            =       celldata(find(celldata (:,3) == Cells(ii)),:);
                celldata_m      =       [celldata_m;temp];
            end
            tt                  =       find(celldata_m(:,CELL_INDOOR) == 1);
            label_GR1           =       length(tt);
        end
        celldata_m              =       [];
        temp                    =       [];
    %% Generic Rule 2*: check the Centroids Separation in a same call. (Optional)
    %% F2: check the serving cell: indoor -> 1; outdoor ->0;
    SC_NEW                 =       m(1,SC_COL);
    Servingcell            =       celldata(find(celldata (:,3) == SC_NEW),:);
    label_GR2              =       Servingcell(1,18);
    label_GR2(label_GR2 == 0)      =       0.5;
    % Indoor Rules 1: Check if Neighbor Measurements = 0;
    %% F3: Collect the number of Neighbor Measurements;
    NB_Cells                   =       m(1,NB_COL);%
    index1                     =       find(NB_Cells  ~= -1);
    NB_Cells                   =       NB_Cells (index1);
    label_IR1                  =       length(NB_Cells); 
    % Indoor Rules 2: Check if #Neighbor Measurements ? 4 && %&#Measured Outdoor Cells > #Measured Indoor Cells
    %% F4 & F5: Mark the MR that has more than 4 NM & list the ratio of #In/#(In+Out);
    label_IR2 = 0;
    if ~isnan(NB_Cells)
         if length(NB_Cells)       >=      4
             label_IR2 = 0; % # NB >=4, mark as 0;
        for ii   =   1:length(NB_Cells)
            temp            =       celldata(find(celldata (:,3) == NB_Cells(ii)),:);
            celldata_m      =       [celldata_m;temp];
        end
            ttt                  =       find(celldata_m(:,CELL_INDOOR) == 1);  
            label_IR2 = length(ttt)/(label_IR1);
         end
    end
            celldata_m              =       [];
            temp                    =       [];
    % Indoor Rules 3:IndoorServing vs. Strongest Outdoor Cell :X = ?RSRP + 1.5*?RSRQ.
    % X ? 0 ? f(x) = 1?(0.5?e^((?x^2)/(2?5^2 )); X < 0 ? f(x) = 0.5?e^((?x^2)/(2?5^2 )
    %% F6:
    rsrp                    =       m(1,NB_RSRP);
    rsrq                    =       m(1,NB_RSRQ);
    rsrp                    =       rsrp(index1); % 1/17
    rsrq                    =       rsrq(index1);
    c                       =       5;
    label_IR3     =     0;
    label_IR4     =     0;
    if ~isnan(NB_Cells)
        for ii   =   1:length(index1)
            temp            =       celldata(find(celldata (:,3) == NB_Cells(ii)),:);
            celldata_m      =       [celldata_m;temp(1,:)];
        end
        
        if label_GR2 == 1
            ind_nb                 =       find(celldata_m(:,CELL_INDOOR) == 0);
        else    
            ind_nb                 =       find(celldata_m(:,CELL_INDOOR) == 1);
        end
        
        if ~isnan(ind_nb)
            rsrp            =       rsrp(ind_nb);
            rsrp                    =       rsrp(rsrp ~= -1); %1/17
            [oi_RSRP,kkk]   =       max(rsrp);

            rsrq            =       rsrq(ind_nb);
            rsrq                    =       rsrq(rsrq ~= -1); %1/17
            oi_RSRQ         =       rsrq(kkk);        

            io_RSRP          =       m(1,SS_COL(1));
            io_RSRQ          =       m(1,SS_RSRQ(1));

            label_IR3        =      io_RSRP-oi_RSRP;
            label_IR4        =      io_RSRQ-oi_RSRQ;
        
             x_value         =       (io_RSRP-oi_RSRP) + 1.5 * (io_RSRQ-oi_RSRQ);
             if x_value >= 0
                 label_IR3     =       1 - 0.5 * exp(- x_value^2 / (2*c^2));
             elseif x_value < 0
                 label_IR3     =       0.5 * exp(- x_value^2 / (2*c^2));
             end
        end
    end
        
   %% F7: TA varies in a same call??
         ta                      =       meas(:,TA_COL);
         label_OR1               =       0.5*ones(length(ta),1);
         ind                     =       find( ~ isnan(ta));
         ta                      =       ta(ind);
         for j = 2:length(ind)
             if ta(j)-ta(j-1) >= 78*2
                 label_OR1(ind(j))       =       0;
             end
         end
   %% F8 Hata Channel Model
     if label_GR2 == 0
        cc                          =           8;
        rstp                        =           m(1,RSTP);
        ta                          =           m(1,TA_COL);
        freq                        =           m(1,DL_FREQ);
        if rstp == 0 
            rstp = 40;
        end

         if freq == 0
         freq = 2100;
         end

        if ta == 0
            ta = 78;
        end

        EstimatedRSRP               =           10 * log10(1000*rstp) - (46.3 + 33.9 * log10(freq) - 6.55 * log10((ta + 78)/1000) + 3);
        EstimatedRSRP               =           10 * log10(1000*rstp) - (46.3 + 33.9 * log10(freq) + 44.9 * log10(ta /1000) + 3);
        ServingRSRP                 =           m(1,SS_COL(1));
        x_value                     =           EstimatedRSRP - ServingRSRP;

        if  ~isnan(x_value)
            if x_value >= 0
                label_OR4        =           1 - exp(- x_value^2 / (2*cc^2));
            else
                label_OR4        =           0;    
            end
        end
     else
        label_OR4        =           1;
     end
        labels_tmp             =       [labels_tmp;label_GR1,label_GR2,label_IR1,label_IR2,label_IR3,label_IR4,label_OR4];
        labels_tmp             =       [labels_tmp;label_IR1,label_OR4];

    end
        %%
    labels = labels_tmp;
end
