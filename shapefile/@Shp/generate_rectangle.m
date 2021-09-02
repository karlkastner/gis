% Thu 11 Jun 10:53:01 +08 2020
function shp = generate_rectangle(x0,y0,x1,y1)
	shp = struct();
	shp.Geometry = 'Polygon';
	shp.ID = 1;
	shp.X = [x0, x1, x1, x0, x0];
	shp.Y = [y0, y0, y1, y1, y0];
end
