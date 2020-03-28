% Wed 13 Nov 15:11:02 +08 2019
function [l] = length2(shp)
	l = zeros(length(shp),1);
	for idx=1:length(shp)
		X = shp(idx).X;
		Y = shp(idx).Y;
		dl = hypot(diff(X),diff(Y));
		l(idx) = nansum(dl);
	end
end

