% Do 19. Nov 15:07:06 CET 2015
% Karl Kastner, Berlin
%
% TODO the bankline polygon has locally to be sampled with higher resolution than the channel width
function [centre, Pv, C] = from_polygon(Xp,Yp)

	% voronoi diagram of boundary polygon
	fdx   = isfinite(Xp);
	Xf    = Xp(fdx);
	Yf    = Yp(fdx);
	XYf   = [cvec(Xf),cvec(Yf)];
	[XYf] = unique(XYf,'rows');
	Xf = XYf(:,1);
	Yf = XYf(:,2);
	[Pv, C] = voronoin(XYf);

	% egdes of cells of the voronoi diagram
	ne = 0;
	% allocate memory
	E = zeros(6*length(Xf),3);
	% index of one polygon point related to the voronoi point
	I  = cell(size(Pv,1),1); %zeros(size(Pv,1),3);
	nI = zeros(size(Pv,1),1);
	% for each voronoi cell
	for idx=1:length(C)
		c = C{idx};
		% somehow voronoin sometimes yields empty cells, skip these
		if (length(c) > 0)
		% collect edges into E
		for jdx=1:length(c)-1
			ne = ne+1;
			E(ne,1) = c(jdx);
			E(ne,2) = c(jdx+1);
			% index of associated point on the boundary
			% there are two, but the distance is equal
			E(ne,3) = idx;
			% centreline point to boundary point index
			nI(c(jdx)) = nI(c(jdx))+1;
			I{c(jdx)}(nI(c(jdx))) = idx;
		end
		% last point
		nI(c(end)) = nI(c(end))+1;
		I{c(end)}(nI(c(end))) = idx;
		ne = ne+1;
		E(ne,1) = c(end);
		E(ne,2) = c(1);
		E(ne,3) = idx;
		end % if length c > 0
	end
	% truncate
	E = E(1:ne,:);
	% sort edges, smallest index first
	E(:,1:2) = [min(E(:,1:2),[],2) max(E(:,1:2),[],2)];
	% make unique
	% TODO, this can be directly done in the loop
	[void, ic] = unique(E(:,1:2),'rows');
	E = E(ic,:);

	% keep all edges (Pv) completely inside the polygon (Xp,Yp)
	in = Geometry.inPolygon(Xp,Yp, Pv(:,1),Pv(:,2));
	%in = inpolygon(Pv(:,1),Pv(:,2),Xp,Yp);
	in_ = in(E(:,1)) & in(E(:,2));
	E   = E(in_,:);
	
	% remove outside points from P and update indices in E
	X = Pv(in,1);
	Y = Pv(in,2);
	I = I(in);
	id = cumsum(in);

	% third index remains
	E(:,1) = id(E(:,1));
	E(:,2) = id(E(:,2));

	%plot(X(E(:,1:2))',Y(E(:,1:2))')
	% pause


	% distance to the 

	% cocatenate line segments to form a graph
	[seg, junction] = Centreline.connect_graph(X, Y, E);

	% average two neighbouring edges to avoid zig-zagging
	% and complete width by adding distance to both sides
	% TODO, because segments are mutually exclusive that can be done in place
	% w = cell(length(seg),1);
	S0 = zeros(length(seg),2);
	n  = length(X);
	X  = [X; zeros(n,1)];
	Y  = [Y; zeros(n,1)];
	width = NaN(2*n,1);
	for idx=1:length(seg)
		id = seg{idx};
		x = X(id);
		y = Y(id);
		xc = 0.5*(x(1:end-1)+x(2:end));
		yc = 0.5*(y(1:end-1)+y(2:end));
		%n = length(X);
		%m = length(xc);
		ni = length(xc);
		% width
		x = [x(1) rvec(xc) x(end)];
		y = [y(1) rvec(yc) y(end)];
		% compute width
		id_ = cellfun(@(x) x(1),I(id));
		[xb s t] = Geometry.base_point([rvec(Xf(id_)); rvec(Yf(id_))] ...
                                               , [x(1:end-1); y(1:end-1)], [x(2:end); y(2:end)]);
		%w{idx}    = cvec(2*t);

		% Note: width at last and first point is not unique
		widthi = cvec(2*t);

		% for the end points translate to SN
		% TODO, only if this is a junction
		s = [0; cvec(cumsum(hypot(diff(x),diff(y))))];
		fdx = find(I{id(1)} > 0);
		[S N] = xy2sn(x',y',s,Xf(I{id(1)}(fdx)),Yf(I{id(1)}(fdx)));
		fdx = find(S > 0);
%		if (3 == length(fdx))
		if (~isempty(fdx))
			S0(idx,1) = max(S(fdx));
		end
%		end
		fdx = find(I{id(end)} > 0);
		%if (3 == length(fdx))
		[S N] = xy2sn(x',y',s,Xf(I{id(end)}(fdx)),Yf(I{id(end)}(fdx)));
		fdx = find(S < s(end));
		if (~isempty(fdx))
			S0(idx,2) = min(S(fdx));
		else
			S0(idx,2) = s(end);
		end

		seg{idx} = [seg{idx}(1), n+1:n+ni, seg{idx}(end)];
		% concatenate points, old points remain as junk
		X(n+1:n+ni) = xc;
		Y(n+1:n+ni) = yc;
		% TODO copies unnessesarily twice
		wc = 0.5*(widthi(1:end-1)+widthi(2:end));
		width(n+1:n+ni) = wc;
		n = n+ni;
	end


	% remove points that are not any more used due to averaging
	np = 0;
	id     = zeros(size(X,1),1);
	X_     = zeros(size(X,1),1);
	Y_     = zeros(size(X,1),1);
	width_ = zeros(size(X,1),1);
	for idx=1:length(seg)
		id_ = seg{idx};
		for jdx=1:length(id_)
			if (id(id_(jdx)) > 0)
				id_(jdx) = id(id_(jdx));
			else
				np = np+1;
				X_(np) = X(id_(jdx));
				Y_(np) = Y(id_(jdx));
				width_(np) = width(id_(jdx));
				id(id_(jdx)) = np;
				id_(jdx) = np;
			end
		end
		seg{idx} = id_;
	end % for idx

	% update junction indices
	for idx=1:length(junction)
		junction(idx).pid = id(junction(idx).pid);
		% sid remains the same
	end
	X     = X_(1:np);
	Y     = Y_(1:np);
	width = width_(1:np);

	centre         = Centreline();
	centre.X       = X;
	centre.Y       = Y;
	centre.width_  = width;
	centre.segment = Segment(centre,seg);
	centre.segment.init();

	% determine local channel width
%	centre.determine_width(Xp,Yp);
%	centre.segment.w  = w;
	centre.segment.S0 = S0;
	centre.segment.junction = junction;

%	centre.w   = w;
%	w = cellfunc(@times,w,0.5,'uniformoutput',false);
%	centre.left  = 0.5*w;
%	centre.right = 0.5*w;
end % centreline_voronoi

