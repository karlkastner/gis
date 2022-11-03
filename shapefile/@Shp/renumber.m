% 2015-09-29 13:42:22.510783752 +0200 renumber.m
%
%% generate a new index
%
function shp = renumber(shp)
%	shp = obj.shp;
	for idx=1:length(shp)
		shp(idx).Id = idx;
	end
%	obj.shp = shp;
end

