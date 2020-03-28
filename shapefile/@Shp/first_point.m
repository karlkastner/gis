% Fri 12 Oct 21:36:10 CEST 2018
function shp_ = first_point(shp,d)
	if (nargin()<2)
		d = 1;
	end
	shp_ = struct();
%	shp_.X = arrayfun(@(x) x.X(1),shp);
%	shp_.Y = arrayfun(@(x) x.Y(1),shp);
	f_C = fieldnames(shp);
	for idx=1:length(shp)
	for f=rvec(f_C);
		switch (f{1})
			case {''}%'X','Y'}
				% nothing to do
			otherwise
				% TODO unsave if d>len
				if (length(shp(idx).(f{1})) == length(shp(idx).X))
					shp_(idx).(f{1}) = shp(idx).(f{1})(d);
				end
		end
	end
	end
	shp_ = Shp.set_geometry(shp_,'Point');
end

