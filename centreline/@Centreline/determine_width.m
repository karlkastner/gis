% Sa 21. Nov 12:27:56 CET 2015
% Karl Kastner, Berlin
% TODO, should be member of segment
function obj = determine_width(obj,Xp,Yp)
	% TODO, no magic numbers
	R         = 1e7;

	obj.seg.w = cell(obj.seg.n,1);
	
	% width
	for idx=1:obj.seg.n
		seg = obj.seg.id{idx};
		n = length(seg);
		% mid points
		xc = obj.seg.Xc(idx);
		yc = obj.seg.Yc(idx);
		% unit normals
		[odx ody] = obj.seg.normal(idx);
		odx = cvec(odx);
		ody = cvec(ody);
		% determine intersections with the polygon
		[xi yi ii] = polyxpoly(flat([xc-R*odx xc+R*odx NaN(n-1,1)]'), ...
		                       flat([yc-R*ody yc+R*ody NaN(n-1,1)]'), ...
					Xp, Yp);

		i1 = ceil(ii(:,1)/3);
		w = NaN(n-1,1);
		% for each sub-segment
		for jdx=1:n-1
			fdx = find(i1 == jdx);
			if (~isempty(fdx))
				% distance to closest interctions on the left and right
				d = hypot(xc(jdx) - xi(fdx), yc(jdx) - yi(fdx));
				d = sort(d);
				% TODO, this should distinguished between left and right by rotation
				if (1 == length(d))
					warning(sprintf('segment %d %d has only one boundary intersection',idx,jdx));
					w(jdx) = 2*d(1);
				else
					%w(jdx) = 2*d(1);
					w(jdx) = d(1)+d(2);
				end
			else
				warning(sprintf('segment %d %d has no boundary intersection',idx,jdx));
			end
	         end % for jdx
		obj.seg.w{idx} = w;
	end % for idx
end % function determine_width

%{
	% the edge with exactly one point in the polygone cut the bankline
	fdx = (1 == sum(in));
	vx3 = vx(:,fdx);
	vy3 = vy(:,fdx);
	n3 = in(:,fdx);
	vx3(3,:) = NaN;
	vy3(3,:) = NaN;
	in3(3,:) = false;
	% interior point of the bank line normals
	Xin = cvec(vx3(1,:).*in3(1,:) + vx3(2,:).*in3(2,:));
	Yin = cvec(vy3(1,:).*in3(1,:) + vy3(2,:).*in3(2,:));
	vx3 = flat(vx3);	
	vy3 = flat(vy3);	
%	in2_ = in3;
	in3 = flat(in3);

	% determine intersections
	[Xon,Yon,ii] = polyxpoly(vx3,vy3,X,Y);
	% distance to left or right bank (not yet equal half-width)
	i1 = ceil(ii(:,1)/3);
	dbank_ = hypot(Xon - Xin(i1), Yon - Yin(i1));
	% associate centreline points with distance to the bank
	dbank = NaN(size(vx_,2),1);
	% TODO, inefficient, use a tree
	for idx=1:length(dbank)
		d2 = (Xin - vx_(idx)).^2 + (Yin - vy_(idx)).^2;
		fdx = find(d2 < abstol);
		% there should be a 1:1 relation
		switch (length(fdx))
		case {0}
			warning('no relation found');
		case {1}
			dbank(idx) = dbank_(fdx);
		otherwise
			warning('relation is ambiguous');
			dbank(idx) = mean(dbank_(fdx));
		end % switch fdx
	end % for idx
	%sum(isfinite(dbank))/length(dbank)
	%max(sum(in3))
	%pause
%}


