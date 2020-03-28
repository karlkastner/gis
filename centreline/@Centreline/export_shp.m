% Wed Dec  3 17:41:03 CET 2014
% Karl Kastner, Berlin

% ESRI shape file export of the centreline
function [shp obj] = export_shp(obj)
	shp = struct();
	for idx=1:obj.segment.n
		shp(idx).Geometry = 'Line';
		shp(idx).X = obj.segment.X(idx);
		shp(idx).Y = obj.segment.Y(idx);
	end
end

