% 2015-11-28 15:30:37.260342929 +0100
function shp = remove_short_elements(shp,lmin)
	if (nargin() < 2)
		lmin = 3;
	end
	l    = arrayfun(@(x) length(x.X),shp);
	shp  = shp(l >= lmin);
end

