% 2018-11-16 16:41:44.533253121 +0100
%% number of points of each feature
function [l] = length(shp)
	l = zeros(size(shp));
	for idx=1:length(shp)
		l(idx) = length(shp(idx).X);
	end
end

