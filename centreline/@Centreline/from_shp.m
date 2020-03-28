
function obj = from_shp(shp)
	[centre seg_id] = Shp.flat(shp);
	obj.X   = centre.X;
	obj.Y   = centre.Y;
	obj.seg = centre.seg;
end

