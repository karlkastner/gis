% alternatively the interpolation can be made continuosly quadratic
% by interpolating from the left and the right point including derivatives
% and than interpolating between both interpolation
function xy2sn_quadratic()
	% generate cubic splines for each centre line segment
	% get spline segment for each source point
	% find parametric roots of N^2 = (x(t)-x0)^2 + (y(t)-y0)^2
	% x and y from parametric form
	% compute N for each root
	% select smallest N
	% convert parameter t to S
end

