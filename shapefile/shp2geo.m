% Sat Mar 15 13:03:14 WIB 2014
% Karl Kastner, Berlin
% reads Polygons (or Line loops) from an ESRI shapefile and converts them into a geometry input file for gmsh
function shp2geo(iname,oname,varargin)
	if (nargin() < 2 || isempty(oname))
		oname = [iname(1:end-4),'.geo'];
	end
	% load input data
	shp = Shp.read(iname);
	Shp.export_geo(shp, oname, varargin{:});
end % shp2geo

