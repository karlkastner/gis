% 2015-12-01 16:23:20.423684765 +0100
%% concatenate two shapefiles
function shp1 = concat(shp1,shp2)
	for idx=1:length(shp2)
		shp1(end+1).X = shp2(idx).X;
		shp1(end+1).Y = shp2(idx).Y;
	end
end
