	function [l] = length(shp)
		l = zeros(size(shp));
		for idx=1:length(shp)
			l(idx) = length(shp(idx).X);
		end
	end

