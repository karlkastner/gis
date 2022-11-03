% Mi 28. Okt 09:49:58 CET 2015
% Karl Kastner, Berlin
%
%% resample coordinates
%
% TODO base element size on curvature
% TODO skip rather than interpolate to preserve density in high curvature places
	%  get ds -> step in ds by factor
	%  get current step length
	% integrate 
function out = resample(shp,resolution,skipshort)
    isz = isfield(shp,'Z');
    imethod = 'pchip';
    limit = 0;
    if (nargin() < 3)
	skipshort = true;
    end

    if (isfield(shp(1),'Geometry'))
    switch (lower(shp(1).Geometry))
    case {'point'}
	error('resampling for points not implemented');
    case {'line'}
	limit = 2;
    case {'polygon'}
	limit = 3;
    otherwise
	error('Unimplmeneted Geometry');
    end
    else
	warning('Geometry not specified, assuming line');
	limit = 2;
    end


    out = struct();

    seg_C = Shp.segment(shp);
    % for each polygon or line
    for idx=1:length(shp)
        % Todo, resample other fields
        out(idx).X = [];
        out(idx).Y = [];
	if (isz)
	        out(idx).Z = [];
	end
        out(idx).resolution = [];
        X = cvec(shp(idx).X);
        Y = cvec(shp(idx).Y);
	if (isz)
   	     Z = cvec(shp(idx).Z);
	end
	% resampling resolution
	if (isfield(shp,'resolution'))
		R = cvec(shp(idx).resolution);
	else
		R = repmat(resolution,length(X),1);
	end
        seg = seg_C{idx};
        % for each segment
        for jdx=1:size(seg,1)
            % surface should at least have 3 points, lines 2 points skip shorter entries
            if (seg(jdx,2) - seg(jdx,1) >= limit)
                % transform to parametric coordinates
                fdx = seg(jdx,1):seg(jdx,2);
		%(sqrt(diff(X(fdx)).^2 + diff(Y(fdx)).^2))];
		dt  = hypot(diff(X(fdx)),diff(Y(fdx)));
                T   = [0; cumsum(dt)];
                % skip duplicate points
		% TODO better use an floating point eps here
                gdx = [1; find(T(2:end)>T(1:end-1))+1];
                T   = T(gdx);
                fdx = fdx(gdx);
                XY  = [X(fdx) Y(fdx)];
		if (isz)
                	XY  = [XY Z(fdx)];
		end
                m = length(T);
                if (isempty(R))
                    n   = length(fdx);
                else
                    % number of elements to achieve desired resolution
                    n = round((T(end)/R(fdx(1))));
                end % if
		% TODO short segments are still not handled well (must have 3 points for surfaces)
                if (~skipshort || (n > 1 && m > 1))
                    if (isempty(R))
                        % do not resample
                        Ti = T;
                        XYi = XY;
                    else
			% resample with local resolution
			Ti = 0;
			for kdx=1:length(T)-1
				while (Ti(end)+R(fdx(kdx)) < T(kdx+1))
					Ti(end+1) = Ti(end) + R(fdx(kdx));
				end % while
			end % for kdx
			if (1==length(Ti))
				Ti(end+1) = T(end);
			end
			% scale to exact length
			Ti = (T(end)/Ti(end))*Ti;
			%Ti(end) = T(end);
                        % resample into n-points
                        %Ti = linspace(0,T(end),n)';
	
			% interp1 complaints if there are no valid samples, so capture this here
			XYi = NaN(length(Ti),size(XY,2));
			for kdx=1:size(XY,2)			
				fidx = isfinite(XY(:,kdx));
				if (sum(fidx)>2)
		                        XYi(:,kdx) = interp1(T(fidx),XY(fidx,kdx),Ti,imethod);
				end
			end

%			if (norm(round((XY(1,:)-XYi(1,:)))) > 0)
%				error('here')
%			end
%			if (norm(round((XY(end,:)-XYi(end,:)))) > 0)
%				error('here')
%			end
          %              [Ri] = interp1(T,R,Ti,imethod);
%                        [XYi] = interp1(T,XY,Ti,'nearest');
                    end % if ~isempty(R)
                    out(idx).X = [out(idx).X; NaN; XYi(:,1)];
                    out(idx).Y = [out(idx).Y; NaN; XYi(:,2)];
		    if (isz)
                    out(idx).Z = [out(idx).Z; NaN; XYi(:,3)];
		    end
           %         out(idx).resolution = [out(idx).resolution NaN Ri];
                else
			fprintf('Skipping short segment\n');
		end
	    else
		fprintf('Skipping empty segment\n');
            end % if seg
        end % for jdx
    end % for idx
end % resample

