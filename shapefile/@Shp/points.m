% Fri 12 Oct 15:41:02 CEST 2018
%% returns points of the features
function shp_a = points(shp)
	shp=Shp.remove_nan(shp);
	X = num2cell([shp.X]);
	[shp_a(1:length(X)).X] = X{:}; 
	Y = num2cell([shp.Y]);
	[shp_a(1:length(X)).Y] = Y{:}; 
	[shp_a(1:length(X)).Geometry] = deal('Point');
	Id = num2cell(1:length(X));
	[shp_a(1:length(X)).Id] = Id{:};
end

