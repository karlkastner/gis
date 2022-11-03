% Sun Jul 13 21:52:13 WIB 2014
% Karl Kastner, Berlin
%
%% read shapefile with z-data from file
%% this is a workaround, as matlab cannot read files with z-data
%
function shp = readZ(shpname,Geometry)
	tmpname = [ tempname() '.shp' ];
	if (nargin()<2)
		% POLYGON
		% ARC
		Geometry='POINT'; % ARC
	end
	%system(['LD_LIBRARY_PATH= ogr2ogr -f "ESRI Shapefile" ' tmpname ' ' shpname ' -where OGR_GEOMETRY=',Geometry]);
	system(['LD_LIBRARY_PATH= ogr2ogr -f "ESRI Shapefile" ' tmpname ' ' shpname ' -lco SHPT=',Geometry]);
	shp = shaperead(tmpname);
end % shapereadZ

