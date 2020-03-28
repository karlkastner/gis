% 2014-12-19 15:23:34.045366007 +0100
% Tue Dec 16 15:23:29 CET 2014
% Karl Kastner, Berlin
%
% true distance between two points in a network along the centreline
% this distance is not directional
%
% function [dmin, node, ppath, spath, npath, S] = distance(obj,x1,y1,x2,y2,scaleflag)
%
function [dmin, node, ppath, spath, npath, S] = distance(obj,x1,y1,x2,y2,scaleflag)
    index_based = false;
    if (nargin() < 6)
	scaleflag = [];
    end
    if (   ~all(isfinite(x1)) ...
	|| ~all(isfinite(y1)) ...
	|| ~all(isfinite(x2)) ...
	|| ~all(isfinite(y2)) )
	error('All input coordinates must be finite')
    end
	
    % get the segment, left and right node id
    % as well as distance to the first point
    [sdx1, dl1, dr1, S1, pdx1] = obj.find_nearest_segment(x1,y1);

    % get the left and right node of the first point
    [sdx2, dl2, dr2, S2, pdx2] = obj.find_nearest_segment(x2,y2);

    d = zeros(5,length(x1));

    % TODO, this is buggy, as segment connects to itself, should not be the case
    % left-left
    d(1,:) = obj.segment.D(obj.segment.node(sdx1,1),obj.segment.node(sdx2,1)) + dl1 + dl2;
    % left-right
    d(2,:) = obj.segment.D(obj.segment.node(sdx1,1),obj.segment.node(sdx2,2)) + dl1 + dr2;
    % right-left
    d(3,:) = obj.segment.D(obj.segment.node(sdx1,2),obj.segment.node(sdx2,1)) + dr1 + dl2;
    % right-right
    d(4,:) = obj.segment.D(obj.segment.node(sdx1,2),obj.segment.node(sdx2,2)) + dr1 + dr2;

    % direct (note: within segment connection is not necessarily shorter if there are circles)
    d(5,:)   = abs(S1 - S2);
    fdx      = (sdx1 ~= sdx2);
    d(5,fdx) = Inf;

    % TODO, there is a 6th possibility when a circle consists of only 1 element,
    % however, this does not occur here, as centrelines come from voronoi polygons
    
    [dmin, mdx] = min(d);

    % TODO, the remaining part is not yet vectorised
    if (nargout() > 1)
        switch (mdx)
            case {1}
                node = [obj.segment.node(sdx1,1); obj.segment.node(sdx2,1)];
            case {2}    
                node = [obj.segment.node(sdx1,1); obj.segment.node(sdx2,2)];
            case {3}    
                node = [obj.segment.node(sdx1,2); obj.segment.node(sdx2,1)];
            case {4}    
                node = [obj.segment.node(sdx1,2); obj.segment.node(sdx2,2)];
            case {5}
                node = [NaN; NaN];
            otherwise
                error('distance');
        end % switch mdx
    
        % calculate the path, if requested    
        % TODO, this is only implemented for scalar queries
        if (nargout() > 2)
            % sparse distance matrix
            [sD Sid] = obj.weighed_connection_matrix(scaleflag);
	    % node (end point) path
            switch (mdx)
                case {1}
                    [d_ npath] = graphshortestpath(sD, obj.segment.node(sdx1,1), obj.segment.node(sdx2,1));
                case {2}
                    [d_ npath] = graphshortestpath(sD, obj.segment.node(sdx1,1), obj.segment.node(sdx2,2));
                case {3}
                    [d_ npath] = graphshortestpath(sD, obj.segment.node(sdx1,2), obj.segment.node(sdx2,1));
                case {4}
                    [d_ npath] = graphshortestpath(sD, obj.segment.node(sdx1,2), obj.segment.node(sdx2,2));
            otherwise
		% start segment is end segment
		npath = [];
		node = [];
		spath = sdx1;
		id  = obj.segment.id{sdx1};
		fdx = [find(pdx1 == id),find(pdx2 == id)];
		%[fdx sdx] = sort(fdx);
		%ppath = id(fdx(1):fdx(2));
		% preserve direction
		if (fdx(1) < fdx(2))
			ppath = id(fdx(1):fdx(2));
		else
			ppath = id(fdx(1):-1:fdx(2));
		end
		S   = obj.seg_S(ppath);
		S   = S-S(1);
		return;
             end % witch mdx
    
            % node path to segment path
            nodei    = obj.segment.nodei;
            spath    = zeros(length(npath)+1,1);
	    spath(1) = sdx1;
            seg_id   = obj.segment.seg_id;
            for idx=1:length(npath)-1
                % the segment is the segment that is common to two adjacent nodes
%                spath_ = intersect(nodei{npath(idx)},nodei{npath(idx+1)});
		n1 = min(npath(idx),npath(idx+1));
		n2 = max(npath(idx),npath(idx+1));
		spath_ = Sid(n1,n2);
		%if (isempty(spath_))
		if (0 == spath_) %isempty(spath_))
			error('No connection');
		end
                % around islands there can be 2 ways, take shorter way
                Si       = obj.seg_S(seg_id(spath_,2));
                [ms mdx] = min(Si);
                spath(idx+1) = spath_(mdx);
            end % for idx
	    spath(end) = sdx2;

%		figure()
%		plot([x1,x2],[y1,y2],'ok')
%		hold on
%		for idx=1:length(spath)
%			pid = obj.segment.id{spath(idx)};
%			plot(obj.X(pid([1 end])),obj.Y(pid([1 end])),'.-')
%			hold on
%		end
%			pause

        
            % segment path to point path
            if (0 == length(spath))
                % routing between start and end point, no jump over segments
		error('here')
                %ppath = min(pdx1,pdx2):max(pdx1:pdx2);
            else
		if (length(spath) > 2 && (spath(1) == spath(2) || spath(end) == spath(end-1)) )
			error('here');
		end
                % TODO there seems to be a problem with small skipped segments when id is used, so back to distance
                % TODO exlude dubplicate points
                if (~index_based)
		    % distance based connection
                
                    % start segment
                    p0 = cvec(obj.segment.id{spath(1)}); % sdx1
                    p1 = cvec(obj.segment.id{spath(2)});
                    d1 = min(dist(p0(end),p1(1)),dist(p0(end),p1(end)));
                    d2 = min(dist(p0(1),p1(1)),dist(p0(1),p1(end)));
                    % TODO there should be a segment internal index
                    fdx = find(p0 == pdx1);
                    if (d1 < d2)
                        ppath = p0(fdx:end);
                    else
                        ppath = flipud(p0(1:fdx));
                    end % if

                    % interior segments (bring tail and head of segments in right order)
                    for idx=2:length(spath)-1
                        p  = cvec(obj.segment.id{spath(idx)});
                        d1 = dist(ppath(end),p(1));
                        d2 = dist(ppath(end),p(end));
                        if (d1 < d2)
                            ppath = [ppath; p];
                        else
                            ppath = [ppath; flipud(p)];
                        end % if
                    end % for idx
                
                    % last segment
                    p  = cvec(obj.segment.id{spath(end)}); %sdx2
                    d1 = dist(ppath(end),p(1));
                    d2 = dist(ppath(end),p(end));
                    fdx = find(p == pdx2);
                    if (d1 < d2)
                        ppath = [ppath; p(1:fdx)];
                    else
                        ppath = [ppath; flipud(p(fdx:end))];
                    end % if
                
                else % index based
                    % TODO this only works if duplicates where not removed
                    %      better use asymmetric connection matrix
                
                    % start segment
                    p0 =  cvec(obj.segment.id{sdx1});
                    p1 =  cvec(obj.segment.id{spath(1)});
                    if (p0(end) == p1(1) || p0(end) == p1(end))
                        % TODO there should be a segment internal index
                        fdx = find(p0 == pdx1);
                        ppath = p0(fdx:end);
                    else
                        ppath = flipud(p0(1:fdx));
                    end % if
                
                    % interior segments
                    for idx=1:length(spath)
                        if (p(1) == ppath(end))
                            ppath = [ppath; cvec(p)];
                        elseif (p(end) == ppath(end))
                            ppath = [ppath; flipud(cvec(p))];
                        else
                            error('not connected')
                        end % if
                    end % for idx
                
                    % last segment
                    p = cvec(obj.segment.id{sdx2});
                    fdx = find(p == pdx2);
                    if (p(1) == ppath(end))
                        ppath = [ppath; p(1:fdx)];
                    elseif (p(end) == ppath(end))
                        ppath = [ppath; flipud(p(fdx:end))];
                    else
                        error('not connected');
                    end % if
                end % else of if ~index_based
            end % else of if l(sp) > 1
            % path-distance
            S = [0; cvec(cumsum(hypot(diff(obj.X(ppath)),diff(obj.Y(ppath)))))];
        end % if nargout > 2
    end % if (nargout > 1)

    function d = dist(p1,p2)
        d = hypot(obj.X(p1)-obj.X(p2),obj.Y(p1)-obj.Y(p2));
    end
end % path

