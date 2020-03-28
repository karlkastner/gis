% 2015-10-30 19:33:38.593255876 +0100
% Karl Kastner, Berlin

function shp = curvature(shp)
	for idx=1:length(shp)
		c = curvature(shp(idx).X,shp(idx).Y);
		shp(idx).curvature = c;
	end
end % curvature
 
