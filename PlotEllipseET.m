% Ellipse: [centerlat(rad) centerlong(rad) semi-major semi-minor angle(rad) radius]
% refPoint: [lat long] in rad
function PlotEllipseET(Ellipse,refPoint)
ImportedDataFormat;
angleStep = pi/180;
angleList = 0:angleStep:2*pi;
angleList = angleList';
semiMajorForPlot=Ellipse(SEMIMAJOR_COL);
semiMinorForPlot=Ellipse(SEMIMINOR_COL);
ellipseOrientation=Ellipse(ORIENTATION_COL);
centerET=convertlatlong2enu(Ellipse(1,[CENTER_LAT_COL CENTER_LONG_COL]), refPoint);
ellipsePointET = [semiMajorForPlot*cos(angleList)*cos(pi/2-ellipseOrientation)-semiMinorForPlot*sin(angleList)*sin(pi/2-ellipseOrientation)+centerET(1),...
    semiMinorForPlot*sin(angleList)*cos(pi/2-ellipseOrientation)+semiMajorForPlot*cos(angleList)*sin(pi/2-ellipseOrientation)+centerET(2)];
plot(ellipsePointET(:,1),ellipsePointET(:,2),'b','LineWidth', 2);