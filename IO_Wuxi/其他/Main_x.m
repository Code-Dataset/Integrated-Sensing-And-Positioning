function Main()
load chu.mat;
mushroomBooleMatrix=BooleMatrix(chu);
minSup = 0.2;  %设置最小支持度阈值
Apriori(mushroomBooleMatrix,minSup);
end
