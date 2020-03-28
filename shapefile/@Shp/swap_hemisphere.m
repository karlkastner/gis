% 2015-10-30 16:07:23.384062952 +0100
% Karl Kastner, Berlin

function shp = swap_hemisphere(shp)
	for idx=1:length(shp)
		shp(idx).Y = -(1e7-shp(idx).Y);
	end
end

