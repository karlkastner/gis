% Mi 28. Okt 09:49:58 CET 2015
% Karl Kastner, Berlin
% TODO base element size on curvature
% TODO skip rather than interpolate to preserve density in high curvature places
	%  get ds -> step in ds by factor
	%  get current step length
	% integrate 
function out = resample_2(shp,resolution)
    shp = Shp.remove_duplicate_points(shp);

    out = struct();

    imethod = 'PCHIP';

    % get segments
    seg_C = Shp.segment(shp);
    % for each polygon or line
    for idx=1:length(shp)
        % TODO, resample other fields
        out(idx).X = [];
        out(idx).Y = [];
        out(idx).resolution = [];
        X = cvec(shp(idx).X);
        Y = cvec(shp(idx).Y);
	% resampling resolution
	if (isfield(shp,'resolution'))
		R = cvec(shp(idx).resolution);
	else
		R = repmat(resolution,length(X),1);
	end
        seg = seg_C{idx};
        % for each segment
        for jdx=1:size(seg,1)
            % surface should at least have 3 points, skip shorter entries
            % TODO for lines the limit has to be 2 points
            if (seg(jdx,2) - seg(jdx,1) > 2)
                    fdx = seg(jdx,1):seg(jdx,2);
		    % actual resampling
		    [Xi Yi Ri] = resample1(X(fdx),Y(fdx),R(fdx));
		    if (length(Xi) > 3) % last point is first point
		            out(idx).X = [out(idx).X; NaN; Xi(:,1)];
        	            out(idx).Y = [out(idx).Y; NaN; Yi(:,1)];
			    out(idx).resolution = [out(idx).resolution; NaN; Ri];
		    end
           %         out(idx).resolution = [out(idx).resolution NaN Ri];
            end % if seg
        end % for jdx
    end % for idx
end % resample

