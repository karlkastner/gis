% Di 10. Nov 15:45:26 CET 2015
% Karl Kastner, Berlin
%
%% translate coordinates
%
% function shp = translate(shp,x0,y0)
function shp = translate(shp,x0,y0)
	if (nargin()<3)
		xy0 = x0;
		x0 = xy0(1);
		y0 = xy0(2);
	end

	for idx=1:length(shp)
		% was -
		shp(idx).X = shp(idx).X + x0;
		shp(idx).Y = shp(idx).Y + y0;
	end
end
