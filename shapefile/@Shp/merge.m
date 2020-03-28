% 2015-09-29 13:43:49.644185853 +0200
% Karl Kastner, Berlin
% TODO, treat NaN

function obj = merge(obj,test)
	abstol = 1e-3;
	shp = obj.shp;
	while (true)
	n = length(shp);
	dflag = false(n,1);
	uflag = false(n,1);
	
	% merge lines running into each other
	XYs = zeros(n,2);
	XYe = zeros(n,2);
	for idx=1:n
		% start point
		XYs(idx,1)	= shp(idx).X(1);
		XYs(idx,2)	= shp(idx).Y(1);
		% end point
		XYe(idx,1)	= shp(idx).X(end);
		XYe(idx,2)	= shp(idx).Y(end);
	end
	% merge start and end points
	% direction of lines may not be unique
	XY = [XYs; XYe];
	nn = knnsearch(XY,XY,'K',3);
	for idx=1:2*n
		idx_ = mod(idx-1,n)+1;
		% test if segment idx was not yet deleted or used
		if (~dflag(idx_) && ~uflag(idx_))
			if (mod(nn(idx,1)-1,n)+1 ~= idx_)
%				mod(nn(idx,1)-1,n)+1
%			if (nn(idx,1) ~= idx && nn(idx,1) ~= idx_)
				jdx = nn(idx,1);
			else
				jdx = nn(idx,2);
			end
%			if (mod(nn(idx_,1)-1,n)+1 ~= idx_)
%				jdx = nn(idx_,1);
%			else
%				jdx = nn(idx_,2);
%			end
			jdx_ = mod(jdx-1,n)+1;
		%	[idx jdx idx_ jdx_ nn(idx,1) nn(idx,2) mod(nn(idx,1)-1,n)+1 ~= idx_ mod(nn(idx,2)-1,n)+1 ~= idx_ norm(XY(idx,:) - XY(jdx,:))]
			% test that segment jdx was not yet deleted or used
			if (~dflag(jdx_) && ~uflag(jdx_))
				% test if they really run together
				% here no underscore!
				if ( (norm(XY(idx,:) - XY(jdx,:)) < abstol ) ...
                                     && (idx_ ~= jdx_) ...
				     && test(shp(idx_),shp(jdx_)) )
					% natural concatenation
					%[HTHT]
					if (idx ~= idx_ && jdx == jdx_)
						shp(idx_).X = [(shp(idx_).X(1:end-1)) (shp(jdx_).X)];
						shp(idx_).Y = [(shp(idx_).Y(1:end-1)) (shp(jdx_).Y)];
					end
					% second reversed
					%[HTTH]
					if (idx ~= idx_ && jdx ~= jdx_)
						shp(idx_).X = [(shp(idx_).X(1:end-1)) fliplr((shp(jdx_).X))];
						shp(idx_).Y = [(shp(idx_).Y(1:end-1)) fliplr((shp(jdx_).Y))];
					end
					% first reversed
					%[THHT]
					if (idx == idx_ && jdx == jdx_)
						shp(idx_).X = [fliplr(shp(idx_).X(2:end)) (shp(jdx_).X)];
						shp(idx_).Y = [fliplr(shp(idx_).Y(2:end)) (shp(jdx_).Y)];
					end
					% both reversed
					%[THTH]
					if (idx == idx_ && jdx ~= jdx_)
						shp(idx_).X = [fliplr(shp(idx_).X(2:end)) fliplr(shp(jdx_).X)];
						shp(idx_).Y = [fliplr(shp(idx_).Y(2:end)) fliplr(shp(jdx_).Y)];
					end


%					if (idx == idx_)
%						X = rvec(shp(idx_).X(2:end));
%					end
					% check direction
%					if ( (idx ~= idx_ && jdx ~= jdx_) ...
%					  || (idx == idx_ && jdx == jdx_) )
%						% direction change
%						shp(idx_).X = [rvec(shp(idx_).X) fliplr(rvec(shp(jdx_).X))];
%						shp(idx_).Y = [rvec(shp(idx_).Y) fliplr(rvec(shp(jdx_).Y))];
%					else
%						% no direction change
%						shp(idx_).X = [rvec(shp(idx_).X) rvec(shp(jdx_).X)];
%						shp(idx_).Y = [rvec(shp(idx_).Y) rvec(shp(jdx_).Y)];
%					end % if direction change
					uflag(idx_) = true;
					dflag(jdx_) = true;
		%			'honk'
				end % if is radius
			end % if jdx
		end % if idx
	end % for idx
	% delete flagged segments
	shp(dflag) = [];
	% repeat if change
	if (0 == sum(dflag))
		break;
	end
	end % while
	obj.shp = shp;
	obj.renumber();
end

