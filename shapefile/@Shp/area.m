% Fr 27. Nov 16:37:58 CET 2015
% Karl Kastner, Berlin
function a = area(shp)
	a = zeros(length(shp),1);
for idx=1:length(shp)
	X = shp(idx).X;
	Y = shp(idx).Y;
	if (X(end) ~= X(1) && Y(end) ~= Y(1))
		X(end+1) = X(1);
		Y(end+1) = Y(1);
	end
	a(idx) = Geometry.poly_area(cvec(X),cvec(Y));
end % for idx
end % function area
