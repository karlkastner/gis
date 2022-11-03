% Mon 11 May 11:48:05 +08 2020
%
%% copy attributes from one shapefile to the other
%
function shp =  copy_attribute(shp_,shp,ifield,ofield)
	if (nargin()<4)
		ofield = ifield;
	end
	for idx=1:length(shp)
		if (shp(idx).ID ~= shp_(idx).ID)
			error('here');
		end
		shp(idx).(ofield) = shp_(idx).(ifield);
	end
end
