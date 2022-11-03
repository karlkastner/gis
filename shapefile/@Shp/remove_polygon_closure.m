% 2018-05-30 09:55:07.932050874 +0200
%
%% remove last points of polygon if they are identical to the first
%
function shp = remove_polygon_closure(shp)
	tol = sqrt(eps);
	for idx=1:length(shp)
		l = hypot(shp(idx).X(1)-shp(idx).X(end), ...
			  shp(idx).Y(1)-shp(idx).Y(end));
		if (l<tol)
			shp(idx).X(end) = [];
			shp(idx).Y(end) = [];
		end
	end
end
