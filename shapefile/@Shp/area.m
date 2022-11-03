% Fr 27. Nov 16:37:58 CET 2015
% Karl Kastner, Berlin
%% area of  polygon shapes
function a = area(shp)
	a = NaN(length(shp),1);
	for idx=1:length(shp)
		if (isnan(shp(idx).X(end)))
			a(idx) = Geometry.poly_area(cvec(shp(idx).X(1:end-1)),cvec(shp(idx).Y(1:end-1)));
		else
		% TODO check identity of first and last point
		%if (X(end) ~= X(1) && Y(end) ~= Y(1))
		%	X(end+1) = X(1);
		%	Y(end+1) = Y(1);
		%end
		end
	end % for idx
end % function area
