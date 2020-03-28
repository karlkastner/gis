% 2015-10-30 16:18:58.609279369 +0100
% Karl Kastner, Berlin

function shp = set_geometry(shp,geometry)
	n = length(shp);
	cg   = repmat({geometry},n,1);
	[shp(1:n).Geometry] = deal(cg{:});
end
