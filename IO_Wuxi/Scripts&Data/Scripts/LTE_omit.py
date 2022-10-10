####################
# This script is for the data where there is no serving cell RSRP
####################
import os
import pdb
FmtDir = r"C:\Users\EZZHAKA\Desktop\in\\"
#FmtDir = r"C:\Aron_Ericsson\Work_place\z_WuxiDataProcessing\Wuxi_data\\"
#FmtDir2= r"C:\Users\EZZHAKA\Desktop\daochu_3\\"
FmtDir2= r"C:\Users\EZZHAKA\Desktop\daochu_3\\"

origin_str=[
            'All-Time',
            'All-Latitude',
            'All-Longitude',
            'All-Timing Advance',
            'All-Serving Cell Identity[1]',
            'All-Serving Cell DL EARFCN[1]',
            'All-Serving Cell RSRP (dBm)[1]',
            'All-Serving Cell RSRQ (dB)[1]',
            'All-Neighbor Cell Identity[1]',
            'All-Neighbor Cell DL EARFCN[1]',
            'All-Neighbor Cell RSRP (dBm)[1]',
            'All-Neighbor Cell RSRQ (dB)[1]',
            'All-Neighbor Cell Identity[2]',
            'All-Neighbor Cell DL EARFCN[2]',
            'All-Neighbor Cell RSRP (dBm)[2]',
            'All-Neighbor Cell RSRQ (dB)[2]',
            'All-Neighbor Cell Identity[3]',
            'All-Neighbor Cell DL EARFCN[3]',
            'All-Neighbor Cell RSRP (dBm)[3]',
            'All-Neighbor Cell RSRQ (dB)[3]',
            'All-Neighbor Cell Identity[4]',
            'All-Neighbor Cell DL EARFCN[4]',
            'All-Neighbor Cell RSRP (dBm)[4]',
            'All-Neighbor Cell RSRQ (dB)[4]',
            'All-Neighbor Cell Identity[5]',
            'All-Neighbor Cell DL EARFCN[5]',
            'All-Neighbor Cell RSRP (dBm)[5]',
            'All-Neighbor Cell RSRQ (dB)[5]',
            'All-Neighbor Cell Identity[6]',
            'All-Neighbor Cell DL EARFCN[6]',
            'All-Neighbor Cell RSRP (dBm)[6]',
            'All-Neighbor Cell RSRQ (dB)[6]',
            'Message Type',
            'EventInfo',
            'All-Altitude (m)'
            ];

second_str=[
            'TimeCol',
            'Latitude',
            'Longtitude',
            'TaCol',
            'ScPciCol',  
            'ScEarfcnCol',
            'ScRsrpCol',
            'ScRsrqCol',
            'NbPciCol',
            'NbEarfcnCol',
            'NbRsrpCol',
            'NbRsrqCol',
            'Nb2PciCol',
            'Nb2EarfcnCol',
            'Nb2RsrpCol',
            'Nb2RsrqCol',
            'Nb3PciCol',
            'Nb3EarfcnCol',
            'Nb3RsrpCol',
            'Nb3RsrqCol',
            'Nb4PciCol',
            'Nb4EarfcnCol',
            'Nb4RsrpCol',
            'Nb4RsrqCol',
            'Nb5PciCol',
            'Nb5EarfcnCol',
            'Nb5RsrpCol',
            'Nb5RsrqCol',
            'Nb6PciCol',
            'Nb6EarfcnCol',
            'Nb6RsrpCol',
            'Nb6RsrqCol',
            'MessageTypeCol',
            'MessageFilemark',
            'Altitude'
            ];

Meiyongde           =       '1'

#CellIDCol = range(74, 82)
#EcNo = range(82, 98)

# Parse each FMT in the directory
for files in os.walk(FmtDir):
    for names in files:
        kk=-1
for FmtName in names:
    if FmtName.find('.FMT')!=-1: #and FmtName.find('WCDMA')!=-1:
        print(FmtName)    
        FmtFile = FmtDir + FmtName

        MeasurementFile = FmtDir2 + FmtName + '.txt'

        output = open(MeasurementFile,'a')
        i=1

        for line in open(FmtFile,encoding='latin').read().splitlines():
            if i==1:
                element = line.split('\t')
                for ii in range(0,35):
                    for jj in range(0,len(element)):
                        if origin_str[ii]==element[jj]:
                            exec(second_str[ii] + '=' + str(jj+1))

            i=i+1        
        #pdb.set_trace()

        i=1

        for line in open(FmtFile,encoding='latin').read().splitlines():
            
            if i!=1:
                element = line.split('\t')
                Message = element[MessageTypeCol-1]
                
                if element[ScPciCol-1] != '' and element[ScEarfcnCol-1] != '': #and element[ScRsrpCol-1] != '': #and count < 11: # and element[ScRsrpCol-1] != '': 

                    MRType  = 0;

                    for kkk in range(0,len(element)):
                        if element[kkk] == '':
                            element[kkk] = '-1'
                        
                    if Message == 'ML1 Connected Mode LTE Intra-Frequency Measurement Results':
                        MRType  = 1;
                    if Message == 'Measurement Report (UL-DCCH)':
                        MRType  = 2;

                    time=element[TimeCol-1]
                    time=time.split(':')
                    timestamp=float(time[0])*3600+float(time[1])*60+float(time[2])

                    LAT=element[Latitude-1]
                    LONG=element[Longtitude-1]
                                
                    ta=element[TaCol-1]
                                
                    MR = str(timestamp) + ',' + LAT + ',' + LONG + ',' + Meiyongde + ',' + ta

                    ScPci=element[ScPciCol-1]
                    ScEarfcn=element[ScEarfcnCol-1]
                        #ScId=str(ScEarfcn*512+ScPci)
                    ScRsrp=element[ScRsrpCol-1]
                    ScRsrq=element[ScRsrqCol-1]
                                
                    MR = MR + ',' + ScPci + ',' + ScEarfcn + ',' + ScRsrp + ',' + ScRsrq

                    NbPci=element[NbPciCol-1]
                    NbEarfcn=element[NbEarfcnCol-1]
                    NbRsrp=element[NbRsrpCol-1]
                    NbRsrq=element[NbRsrqCol-1]
                                
                    MR = MR + ',' + NbPci + ',' + NbEarfcn + ',' + NbRsrp + ',' + NbRsrq

                    Nb2Pci=element[Nb2PciCol-1]
                    Nb2Earfcn=element[Nb2EarfcnCol-1]
                    Nb2Rsrp=element[Nb2RsrpCol-1]
                    Nb2Rsrq=element[Nb2RsrqCol-1]
                                
                    MR = MR + ',' + Nb2Pci + ',' + Nb2Earfcn + ',' + Nb2Rsrp + ',' + Nb2Rsrq

                    Nb3Pci=element[Nb3PciCol-1]
                    Nb3Earfcn=element[Nb3EarfcnCol-1]
                    Nb3Rsrp=element[Nb3RsrpCol-1]
                    Nb3Rsrq=element[Nb3RsrqCol-1]
                                
                    MR = MR + ',' + Nb3Pci + ',' + Nb3Earfcn + ',' + Nb3Rsrp + ',' + Nb3Rsrq                      

                    Nb4Pci=element[Nb4PciCol-1]
                    Nb4Earfcn=element[Nb4EarfcnCol-1]
                    Nb4Rsrp=element[Nb4RsrpCol-1]
                    Nb4Rsrq=element[Nb4RsrqCol-1]
                                
                    MR = MR + ',' + Nb4Pci + ',' + Nb4Earfcn + ',' + Nb4Rsrp + ',' + Nb4Rsrq

                    Nb5Pci=element[Nb5PciCol-1]
                    Nb5Earfcn=element[Nb5EarfcnCol-1]
                    Nb5Rsrp=element[Nb5RsrpCol-1]
                    Nb5Rsrq=element[Nb5RsrqCol-1]
                                
                    MR = MR + ',' + Nb5Pci + ',' + Nb5Earfcn + ',' + Nb5Rsrp + ',' + Nb5Rsrq
                                
                    Nb6Pci=element[Nb6PciCol-1]
                    Nb6Earfcn=element[Nb6EarfcnCol-1]
                    Nb6Rsrp=element[Nb6RsrpCol-1]
                    Nb6Rsrq=element[Nb6RsrqCol-1]
                                
                    MR = MR + ',' + Nb6Pci + ',' + Nb6Earfcn + ',' + Nb6Rsrp + ',' + Nb6Rsrq

                    Alti = element[Altitude-1]
                        
                    MR = MR + ',' + Alti + ',' + str(MRType) + '\n' 

                    output.write(MR)
            i=i+1
        ##    element = line.split('\t')
        ##    #print(element)
        ##    Message = element[MessageTypeCol-1]
        ##    
        output.close()
