% Sa 21. Nov 14:23:33 CET 2015
% Karl Kastner, Berlin
classdef Segment < handle
	properties
		centre;
		% segment to point index
		id  = {};
		% point ot segment index (inverse index)
		% TODO should be member of Centreline
		rid = [];
		% width
		%w   = {};
		% TODO deprecated
		S0  = [];

		% junction information
		% TODO deprecated
		junction;

		% matrix of shortest distance between segment points
		D     = [];
		% segment to junction node index
		node  = [];
		
		seg_id;
		seg_id_;
		% junction node to segment index (inverse)
		nodei  = {};
		% number of distinct segment end points
		n_node = 0;
	end % properties
	methods
		% pseudo properties
		function [n obj] = n(obj)
			n = length(obj.id);
		end
		% deprecated ?
		function C = node_C(obj)
			C = cell(obj.centre.n,1);
			seg_id = obj.seg_id;
			for idx=1:obj.n
				C{seg_id(idx,1)} = [C{seg_id(1)},idx];
				C{seg_id(idx,2)} = [C{seg_id(2)},idx];
			end
		end
		% constructor
		function obj = Segment(varargin)
			switch (length(varargin))
			case {0}
				% default constructor
			case {2}
				obj.centre = varargin{1};
				obj.id     = varargin{2};

			otherwise
				error('wrong number of input arguments');
			end
		end
		function obj = init(obj)
			% build_forward_index
			obj.init_seg_id();
			obj.build_inverse_index();
		end

		function [X obj] = X(obj,idx)
			X = cvec(obj.centre.X(obj.id{idx}));
		end
		function [Y obj] = Y(obj,idx)
			Y = cvec(obj.centre.Y(obj.id{idx}));
		end
		function [l dx dy obj] = total_length(obj,id)
			if (nargin() < 2)
				id = 1:length(obj.id);
			end
			if (islogical(id))
				id = find(id);
			end
			l = zeros(length(id),1);
			for idx=1:length(id)
				S = obj.S(id(idx));
				l(idx) = S(end);
				%X = obj.X(id(idx));
				%Y = obj.Y(id(idx));
				%dx = diff(X);
				%dy = diff(Y);
				%l(idx) = hypot(dx,dy);
			end
		end
		function [l dx dy obj] = length(obj,id)
			X  = obj.X(id);
			Y  = obj.Y(id);
			dx = diff(X);
			dy = diff(Y);
			l  = hypot(dx,dy);
		end
		function [S obj] = S(obj,idx)
			ds = obj.length(idx);
			S  = [0; cvec(cumsum(ds))];
		end
		function [Sc obj] = Sc(obj,idx)
			S = obj.S(idx);
	 		Sc = 0.5*cvec(S(1:end-1) + S(2:end));
		end
		function [xc obj] = Xc(obj,idx)
			id = obj.id{idx};
	 		xc = 0.5*cvec(  obj.centre.X(id(1:end-1)) ...
                                      + obj.centre.X(id(2:end)));
		end
		function [yc obj] = Yc(obj,idx)
			id = obj.id{idx};
	 		yc = 0.5*cvec(  obj.centre.Y(id(1:end-1)) ...
                                      + obj.centre.Y(id(2:end)));
		end
		function [odx ody obj] = normal(obj,idx)
			id = obj.id{idx};
			[h dx dy] = obj.length(idx);
%			dx = cvec(obj.centre.X(id(1:end-1))-obj.centre.X(id(2:end)));
%			dy = cvec(obj.centre.Y(id(1:end-1))-obj.centre.Y(id(2:end)));
			ih  = 1./hypot(dx,dy);
			odx = -dy.*ih;
			ody =  dx.*ih;
		end % normal
		function [Xl Yl obj] = Pl(obj,idx)
			[odx ody] = obj.normal(idx);
			id        = obj.id{idx};
			w         = obj.centre.width(id);
			w	  = 0.5*(w(1:end-1)+w(2:end));
			%w         = 0.5*obj.w{idx};
			Xl        = obj.Xc(idx) - 0.5*w.*odx;
			Yl        = obj.Yc(idx) - 0.5*w.*ody;
			if (1 == nargout)
				Xl = [Xl Yl];
			end
		end
		function [Xr Yr obj] = Pr(obj,idx)
			[odx ody] = obj.normal(idx);
			id        = obj.id{idx};
			w         = obj.centre.width(id);
			w	  = 0.5*(w(1:end-1)+w(2:end));
			%w         = 0.5*obj.w{idx};
			Xr        = obj.Xc(idx) + 0.5*w.*odx;
			Yr        = obj.Yc(idx) + 0.5*w.*ody;
			if (1 == nargout)
				Xr = [Xr Yr];
			end
		end
		function obj = remove(obj,fdx)
			ddx = true(obj.n,1);
			ddx(fdx) = false;
			obj.id = obj.id(ddx);
			obj.w = obj.w(ddx);
		end

	end % methods
end % class Segment

