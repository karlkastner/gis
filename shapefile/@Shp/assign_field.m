%  shp = assign_field(shp,fieldname,x)
function shp = assign_field(shp,fieldname,x)
	if (~iscell(x))
		x = num2cell(x);
	end
	[shp.(fieldname)] = x{:};
end
