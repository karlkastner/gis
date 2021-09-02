% Mon 12 Oct 12:50:33 +08 2020
function in = inpolygon(shp,x0,y0)
	shp = Shp.remove_nan(shp);
	in = NaN;
	for idx=1:length(shp)
		xp = shp.X;
		yp = shp.Y;
		flag = Geometry.inpolygon(shp(idx).X,shp(idx).Y,x0,y0);
		if (flag)
			in = idx;
			break;
		end
	end
end
