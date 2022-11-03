% Fri 12 Oct 21:36:10 CEST 2018
%
%% return last point of features
%
function [X,Y] = last_point(shp)
	[X] = arrayfun(@(x) x.X(end),shp);
	[Y] = arrayfun(@(x) x.Y(end),shp);
end

