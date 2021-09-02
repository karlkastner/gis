% Tue 12 May 11:46:57 +08 2020
function [shp,zone] = latlon2utm(shp, varargin)
	lon = [shp.X];
	lat = [shp.Y];	
	[easting, northing, zone] = latlon2utm(lat, lon, varargin{:});
	l = arrayfun(@(s) length(s.X),shp);
	id = cumsum([1; l]);
	for idx=1:length(shp)
		shp(idx).X = easting(id(idx):id(idx+1)-1);
		shp(idx).Y = northing(id(idx):id(idx+1)-1);
		shp(idx).zone = zone;
	end
end

