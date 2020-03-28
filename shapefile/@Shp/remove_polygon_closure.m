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
