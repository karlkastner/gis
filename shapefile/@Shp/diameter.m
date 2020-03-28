% Mi 28. Okt 17:58:27 CET 2015
% Karl Kastner, Berlin
% determine diameter of polygon at every element
function shp = diameter(shp)
	% for each polygon
	for sdx=1:length(shp)
	XY = [rvec(shp(sdx).X); rvec(shp(sdx).Y)];
	n = size(XY,2);

	valid = prod(isfinite(XY));
	valid = valid(1:n-1).*valid(2:n);
	invalid = find(~valid);
	d = inf(n-1,1);


	% mid points
	P = 0.5*(XY(:,1:end-1) + XY(:,2:end));
	% normals
	N = P + [-(XY(2,1:end-1)-XY(2,2:end));
	          (XY(1,1:end-1)-XY(1,2:end)) ];
 
	% intersection of segment orthogonals with segments
	[void, S, void, void, Q den] = lineintersect(P,N,XY(:,1:end-1),XY(:,2:end));

%	for idx=1:10
%	for jdx=1:10
%		[v S(idx,jdx) v v Q(1:2,idx,jdx)] = lineintersect(P(:,jdx),N(:,jdx+1),XY(:,idx),XY(:,idx+1));
%		[v S_(idx,jdx) v v Q_(1:2,idx,jdx) den_(idx,jdx)] = lineintersect1(P(:,idx),N(:,idx),XY(:,jdx),XY(:,jdx+1));
%	end
%	end

	% distances to intersection point
	D = sqrt(   bsxfun(@minus,Q(1,:,:),P(1,:)).^2 ...
	          + bsxfun(@minus,Q(2,:,:),P(2,:)).^2 );
	D = squeeze(D);

	% invalidate all invalid segments
	D(invalid,:) = Inf;
	D(:,invalid) = Inf;

	% invalidate all non-intersections
	fdx = ~(S > 0 & S < 1);
	D(fdx) = Inf;

	% invalidate self-intersections (diagonals)
	D = D + diag(sparse(Inf*ones(n-1,1)));

	% closest intersection
	d = min(D)';

	% distribute back to boundary points
	d = [d(1); 0.5*(d(1:end-1)+d(2:end)); d(end)];
	d(~valid) = NaN;
	% write back
	shp(sdx).diameter = d;
	end % for sdx
end % diameter

