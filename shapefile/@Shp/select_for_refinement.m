% Di 3. Nov 11:45:01 CET 2015
% Karl Kastner, Berlin

function shp = select_for_refinement(shp, Xc, Yc, R,ratio)
	X = shp.X;
	Y = shp.Y;
	resolution = shp.resolution;
	masked = false(size(X));
	% determine boundary segments where orthogonality is violated
	for idx=1:length(Xc)
		% find all boundary points close to this triangle
		jdx = (X-Xc(idx)).^2 + (Y-Yc(idx)).^2 < R(idx).^2;
		masked(jdx) = true;
	end
	% reduce characteristic length by a specific factor
	resolution(masked) = ratio*resolution(masked);
	% write back
	shp.resolution = resolution;
end

