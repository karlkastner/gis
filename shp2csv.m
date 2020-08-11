% Tue 12 May 12:57:16 +08 2020
function shp2csv(varargin)
	cmd = ['python ', ROOTFOLDER(), '/src/lib/gis/shp2csv.py ',varargin{:}];
	system(cmd);
end

