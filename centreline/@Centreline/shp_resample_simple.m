shp = shaperead('mat/aux.shp')
XY = interp1(1:length(shp.X),[shp.X', shp.Y'],1:0.25:length(shp.X));
shp.X = XY(:,1); shp.Y=XY(:,2);
shapewrite(shp,'mat/aux.shp')
