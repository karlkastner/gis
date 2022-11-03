% Sa 28. Nov 11:55:24 CET 2015
% Karl Kastner, Berlin
%
%% remove dubplicate points from features
%
function shp = remove_duplicate_points(shp)
	abstol = 1e-3;
	f_C = fieldnames(shp);
	f_C_ = {};
	% only use field names that are vectors of length X
	for idx=1:length(f_C)
		if (isvector(shp(1).(f_C{idx})) ...
                    && (length(shp.X)==length(shp.(f_C{idx}))))
			f_C_{end+1} = f_C{idx};
		end
	end
	f_C = f_C_;
	for idx=1:length(shp)
		X = cvec(shp(idx).X);
		Y = cvec(shp(idx).Y);
		np = length(X);
		fdx = isfinite(shp(idx).X);
		[id_ D] = knnsearch([X(fdx) Y(fdx)],[X(fdx) Y(fdx)],'k',2);
		ddx = false(np,1);
		id  = zeros(np,1);
		id(fdx) = id_(:,2);
		ddx(fdx) = D(:,2) < abstol;
		% delete each point only once by deleting the dublicate with larger index
		% this assumes no triples
		N = (1:np)';
		ddx = ddx & (id > N);
		if (sum(ddx)>0)
			fprintf('Removing %d points\n',sum(ddx));
		end
		for jdx=1:length(f_C)
			shp(idx).(f_C{jdx})(ddx) = [];
		end
	%	shp(idx).X(ddx) = [];
	%	shp(idx).Y(ddx) = [];
	end
	% restore last points for Polygons
	if (isfield(shp,'Geometry') && strcmp(shp.Geometry,'Polygon'))
		shp = Shp.split_nan(shp);
		for idx=1:length(shp);
			if (   shp(idx).X(1) ~= shp(idx).X(end) ...
			    && shp(idx).Y(1) ~= shp(idx).Y(end) )
		%		shp(idx).X(end+1) = shp(idx).X(1);
		%		shp(idx).Y(end+1) = shp(idx).Y(1);
				for jdx=1:length(f_C)
					shp(idx).(f_C{jdx})(end+1) = shp(idx).(f_C{jdx})(1); 
				end
			end
		end
		shp = Shp.cat(shp,NaN);
	end
end

