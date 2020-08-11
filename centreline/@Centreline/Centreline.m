% Wed Nov 19 17:55:58 CET 2014
% Karl Kastner, Berlin

% TODO nodes as duplicates: unique S, but duplicate XY (nearest neighbour search fails)
% also gets rid of the id storage
% needs to create copies for data sets with joint index
% make nearest neighbour search skip duplicates
classdef Centreline < handle
	properties
		% cartesian coordinates
		X
		Y
		% quad tree for fast searching
		qtree;
		% s
%		S
		% distance from centre line to left bank
		% definition of left is arbitrary, e.g. independent of flow direction
		left_
		% distance from centre to right bank
		right_
		% width
		width_
		% curvature
		curvature_;

		% true radius of curvature, not normed by width
%		Rc

		% TODO, move this to a common valuse-struct
		% cross section averaged bottom altitude
		alt_bottom
		% standard error of cross averaged bottom altitude
		serr_alt_bottom 

		% segments
		segment;

		% length of sub-segments
		%w;

		% distance from each point to corresponding segment start point
		seg_S;
		seg_S0;

		% threshold distance for linking elements at junctions
		thresh;
	end % properties
	methods (Static)
		shp        = link_centreline(shp,thresh);
		[centreline, Pv, C] = from_polygon(Xp,Yp);
		centreline = from_shp(shp);
		[X, Y, E] = remove_duplicate_points(X,Y,E);
		[seg, junction] = connect_graph(X, Y, E);
		[X, Y, S, N, sdx, pdx] = snmesh(obj,x0,y0,ds,k);
	end
	methods
		% pseudo variables, contain redundant data and are computed on demand
		function [val, obj] = width(obj,fdx)
			if (nargin() > 1)
				val = obj.width_(fdx);
				%val = abs(obj.left(fdx) - obj.right(fdx));
			else	
				val = obj.width_;
				%val = abs(obj.left - obj.right);
			end
		end % width
		% TODO area is not well defined
%		function [val obj] = area(obj)
%			val = obj.width().*obj.depth;
%		end
		% transformations
		function [X, Y, obj] = sn2xy(obj,S,N)
			warning('individual segment treatment not yet implemented');
			[X, Y] = sn2xy(obj.X,obj.Y,obj.S,S,N);
			%[X Y] = sn2xy(obj.X,obj.Y,obj.S,obj.seg,S,N);
		end % sn2xy
		function [n, obj] = n(obj)
			n = length(obj.X);
		end
		function [l] = left(obj,fdx)
			%dx = cdiff(obj.X);
			%dy = cdiff(obj.Y);
			l = NaN(obj.n,2);
			for idx=1:obj.segment.n
				l(obj.segment.id{idx}(1:end-1),:) = obj.segment.Pl(idx);
			end
			if (nargin() > 1)
				l = l(fdx,:);
			end
		end
		function [r] = right(obj,fdx)
			%dx = cdiff(obj.X);
			%dy = cdiff(obj.Y);
			r = NaN(obj.n,2);
			for idx=1:obj.segment.n
				r(obj.segment.id{idx}(1:end-1),:) = obj.segment.Pr(idx);
			end
			if (nargin() > 1)
				r = r(fdx,:);
			end
		end
		
		% constructor
		% silently assumes, that there are at least 2 different points per segment
		function obj = Centreline(varargin)
			switch (length(varargin))
			case {0}
				% default constructor
				return;
			case {1}
				if (isstr(varargin{1}))
					shp = Shp.read(varargin{1});
				else
					shp = varargin{1};
				end
				shp     = Shp.flat(shp);
				X       = cvec(shp.X);
				Y       = cvec(shp.Y);
				sid     = shp.seg;
			case {3}
				% continue below
				X   = varargin{1};
				Y   = varargin{2};
				sid = varargin{3};
			otherwise
				error('incorrect number of arguments');
			end
			
			% remove invalid points
			fdx = isfinite(X) & isfinite(Y);
			X   = X(fdx);
			Y   = Y(fdx);
			sid = sid(fdx);

			% rebuild seg_id, due to removal of points
			d      = find(diff(sid));
			seg_id = [[1;d+1], [d;length(sid)]];

			% sid itself also has to be rebuild, as some short segments
			% may have been deleted
			for idx=1:size(seg_id,1)
				sid(seg_id(idx,1):seg_id(idx,2)) = idx;
			end

			% sort points according to index
			% TODO assumed sorted for the time being
		%	sid = sort(sid,'stable')
	
			% (re)move duplicate points
			% dublicate points cause problems for the qtree nearest neighbour search
			% it is assumed, that the duplicates are end points only
			% randomly perturb the duplicate coordinates
			% as removing would cause problems
			if (0)
			% TODO, this is a quick fix and makes problems depending on the coordinate is m or degree
			[void, ia] = unique([X, Y],'rows','stable');
			fdx        = true(size(X));
			fdx(ia)    = false;
			X = X + fdx.*rand(length(X),1);
			Y = Y + fdx.*rand(length(X),1);
			end

			% move segment endpoints slightly inward to avoid dubplicate coordinates
			% TODO the perturbed coords actually only need to be used for the nearest neighbour search
			% TODO, no magic number
			% TODO 
			% make the first and last index of a segment special (replaceable)
			% seg_id = [first point, second point, last but one point, last point]
			p = sqrt(eps);
			% move first point slightly towards second point
			X(seg_id(:,1)) = (1-p)*X(seg_id(:,1)) + p*X(seg_id(:,1)+1);
			Y(seg_id(:,1)) = (1-p)*Y(seg_id(:,1)) + p*Y(seg_id(:,1)+1);
			% move other endpoint slightly towards last but one point
			X(seg_id(:,2)) = (1-p)*X(seg_id(:,2)) + p*X(seg_id(:,2)-1);
			Y(seg_id(:,2)) = (1-p)*Y(seg_id(:,2)) + p*Y(seg_id(:,2)-1);

			obj.X      = X;
			obj.Y      = Y;
			
			% all point indices of each segment
			% TODO why is this explicitely necessary?
			id = cell(size(seg_id,1),1);
			for idx=1:size(seg_id,1)
				id{idx} = seg_id(idx,1):seg_id(idx,2);
			end
			obj.segment = Segment(obj, id);
		end % Centreline
	end % methods
end % classdef

