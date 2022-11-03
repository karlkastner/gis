% Thu  8 Dec 16:20:17 CET 2016
%
%% join line segments
%
function shp = join_lines(shp,dmax)
	if (nargin() < 2)
		dmax = sqrt(eps);
	end
	isz = isfield(shp,'Z');
	shp = Shp.split_nan(shp);
	n = length(shp);
	del = [];
	for idx=1:n
	while (true)
		change = false;
		% TODO do not fetch at every iteration but update it
		X0  = [arrayfun(@(s) s.X(1),shp), arrayfun(@(s) s.X(end),shp)];
		Y0  = [arrayfun(@(s) s.Y(1),shp), arrayfun(@(s) s.Y(end),shp)];
		% distance to start point
		d   = hypot(X0-shp(idx).X(1),Y0-shp(idx).Y(1));
		fdx = find(d<dmax);
		fdx = fdx(fdx~=idx & fdx~=(idx+n));
		% one neighbour
		if (1 == length(fdx))
			if (fdx < n)
				shp(idx).X = [flipud(cvec(shp(idx).X));cvec(shp(fdx).X)];
				shp(idx).Y = [flipud(cvec(shp(idx).Y));cvec(shp(fdx).Y)];
				if (isz)
					shp(idx).Z = [flipud(cvec(shp(idx).Z));cvec(shp(fdx).Z)];
				end
			else
				fdx = fdx-n;
				shp(idx).X = [flipud(cvec(shp(idx).X));flipud(cvec(shp(fdx).X))];
				shp(idx).Y = [flipud(cvec(shp(idx).Y));flipud(cvec(shp(fdx).Y))];			
				if (isz)
					shp(idx).Z = [flipud(cvec(shp(idx).Z));flipud(cvec(shp(fdx).Z))];			
				end
			end
			% invalidate concatenated part
			shp(fdx).X = NaN;
			shp(fdx).Y = NaN;
			if (isz)
			end
			del = [del,fdx];
			change = true;
			continue;
		end % 1 == length(fdx)
		% distance to end point
		d   = hypot(X0-shp(idx).X(end),Y0-shp(idx).Y(end));
		fdx = find(d<dmax);
		fdx = fdx(fdx~=idx & fdx~=(idx+n));
		% one neighbour
		if (1 == length(fdx))
			if (fdx < n)
				shp(idx).X = [cvec(shp(idx).X);cvec(shp(fdx).X)];
				shp(idx).Y = [cvec(shp(idx).Y);cvec(shp(fdx).Y)];
				if (isz)
					shp(idx).Z = [cvec(shp(idx).Z);cvec(shp(fdx).Z)];
				end
			else
				fdx = fdx-n;
				shp(idx).X = [cvec(shp(idx).X);flipud(cvec(shp(fdx).X))];
				shp(idx).Y = [cvec(shp(idx).Y);flipud(cvec(shp(fdx).Y))];
				if (isz)
					shp(idx).Z = [cvec(shp(idx).Z);flipud(cvec(shp(fdx).Z))];
				end
			end
			% invalidate concatenated part
			shp(fdx).X = NaN;
			shp(fdx).Y = NaN;
			if (isz)
			end
			del = [del,fdx];
			change = true;
%			continue;
		end
		if (~change)
			break;
		end
	end % while
	end % for
	shp(del) = [];
end % function

%	if (nargin() < 2)
%		dmax = sqrt(eps);
%	end
%
%	shp = Shp.cat(shp,NaN);
%	seg_C = Shp.segment(shp);
%	shp = Shp.split_nan(shp);
%	seg = seg_C{1};
%	X   = shp.X(seg(:));
%	Y   = shp.Y(seg(:));
%	dX  = bsxfun(@minus,X,X');
%	dY  = bsxfun(@minus,Y,Y');
%	D   = hypot(dX,dY);
%	n   = size(seg,1);
%	% number of connecting vertices
%	flag = D<=dmax;
%	nc = sum(flag); % & bsxfun(@smaller,(1:n)',(1:n)));
%	for idx=2:2*n
%		% self + one conneting vertex
%		if (2==nc)
%			jdx = find(flag(:,idx));
%			% do not connect to oneself
%			if (fdx<idx && fdx ~= idx-n )
%				% concatenate fdx to jdx
%				if (idx < n)
%					if (jdx < n)
%						shp.X(idx) = [flipud(cvec(shp.X(idx))),cvec(shp(jdx).X)];
%					else
%						shp.X(idx) = [flipud(cvec(shp.X(idx))),cvec(shp(jdx).X)];
%						
%					end
%				else
%					if (jdx<n)
%					else
%					end
%				end
%				% invalidate second
%				%flag(D(:,jdx)) = 0;
%				%flag(D(jdx,:)) = 0;
%				%flag(D(:,mod(jdx+n,2*n))) = 0;
%				%flag(D(mod(jdx+n,2*n),:)) = 0;
%			end
%		end
%				
%	end
%	end
%
%
