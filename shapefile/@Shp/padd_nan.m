% 2016-09-22 21:33:46.910566353 +0800 padd_nan.m
%
%% padd NaN at end of features
%
function shp = padd_nan(shp)
	for idx=1:length(shp)
		if (~isnan(shp(idx).X(end)))
			shp(idx).X(end+1) = NaN;
			shp(idx).Y(end+1) = NaN;
		end
	end
end
