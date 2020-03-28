% 2015-09-29 12:15:46.301811455 +0200

function shp=remove_nan(shp)
%	shp = obj.shp;
	n = length(shp);
	for idx=1:n
		fdx = isfinite(shp(idx).X) & isfinite(shp(idx).Y);
		shp(idx).X = shp(idx).X(fdx);
		shp(idx).Y = shp(idx).Y(fdx);
	end % for idx
%	obj.shp = shp;
end % remove_nan

