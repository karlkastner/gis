% Mo 26. Okt 07:44:58 CET 2015
% splits shp line and polygons at NaN into two different groups
function out = split_nan(in)
	isz = isfield(in,'Z');
	out = struct();
	k = 0;
	field_C = fieldnames(in);
	for idx=1:length(in)
		if (isfield(in(idx),'Geometry'))
			Geometry = in(idx).Geometry;
			isgeo = true;
		else
			isgeo = false;
		end
		X = rvec(in(idx).X);
		Y = rvec(in(idx).Y);
		if (isz)
			Z = rvec(in(idx).Z);
		end
		if (length(X) > 1)
		fdx = [0, find(isnan(X)), length(X)+1];
		for jdx=2:length(fdx)
			if (fdx(jdx)-fdx(jdx-1)-1 > 0)
				k = k+1;
				out(k).X = X(fdx(jdx-1)+1:fdx(jdx)-1);
				out(k).Y = Y(fdx(jdx-1)+1:fdx(jdx)-1);
				if (isz)
					out(k).Z = Z(fdx(jdx-1)+1:fdx(jdx)-1);
				end
				for f=rvec(field_C)
					switch(f{1})
					case{'X','Y','Z'}
						%nothing
					otherwise
					if (length(in(idx).(f{1})) == length(X))
						out(k).(f{1}) = in(idx).(f{1})(fdx(jdx-1)+1:fdx(jdx)-1);
					end
					end
				end
				if (isgeo)
					out(k).Geometry = Geometry;
				end
			end % if
		end % for jdx
		end
	end % for idx
end % shp_split_nan

