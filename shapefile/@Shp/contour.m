% Mo 7. Dez 18:50:29 CET 2015
function out = contour(shp)
	h = 100;
	% contour line follower
	seg_C = Shp.segment(shp);
	seg_C = seg_C{1};
	% TODO recurse while segments are not empty
	% for each segment
	for idx=1:size(seg_C,1)
		fdx = (seg_C(idx,1):seg_C(idx,2))';
		X = cvec(shp.X(fdx));
		Y = cvec(shp.Y(fdx));
		% for each point, get Rc, x0, y0, dir
		[c Rc] = curvature(X,Y);
		% direction
		% TODO use fourier method
		dir = [cdiff(X), cdiff(Y)];
		hyp = hypot(dir(:,1),dir(:,2));
		dir = [dir(:,1)./hyp dir(:,2)./hyp];
		% orthogonal direction
		odir = [dir(:,2),-dir(:,1)];
		% origin
		X0 = X - Rc.*odir(:,1);
		Y0 = Y - Rc.*odir(:,2);
		% get coordinates of the next level
		X_ = X0+odir(:,1).*(Rc+h);
		Y_ = Y0+odir(:,2).*(Rc+h);
		% TODO resample ?

		% export
		out.X(fdx) = X_;
		out.Y(fdx) = Y_;
		% TODO get intersection with itself
		% this has to happen accross contours
		% TODO compute area
		% TODO remove negative area parts
	end
end % contour

