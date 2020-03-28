% Sun Jul 13 21:52:13 WIB 2014
% Karl Kastner, Berlin
function shp = readZ(shpname,Geometry)
	tmpname = [ tempname() '.shp' ];
	if (nargin()<2)
		Geometry='POINT'; % ARC
	end
	system(['LD_LIBRARY_PATH= ogr2ogr -f "ESRI Shapefile" ' tmpname ' ' shpname ' -lco SHPT=',Geometry]);
	shp = shaperead(tmpname);
end % shapereadZ

