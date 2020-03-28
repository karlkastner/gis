% buffer or shrink a polygon by a fixed distance
% TODO resolv self intersection and remove counter clockwise parts (this would also remove islands)
function shp = buffer(shp,d)
	seg_C = Shp.segents(shp);
	% for each feature
	for idx=1:length(shp)
		seg = seg_C{idx};
		% for each segment
		for jdx=1:size(seg,1)
			fdx = seg(jdx,1):seg(jdx,2);
			X   = cvec(shp(idx).X(fdx));
			Y   = cvec(shp(idx).Y(fdx));
			% get angle of left edge
			% get angle of right edge
			% get angle of halving vector
			a = a1 + 0.5*(a1+a2);
			% direction of halving vector
			dx = cos(a);
			dy = sin(a);

			% TODO, this does not work if the angle is equal or larger than 180 deg
			dxl = circshift(X,-1)-X;
			dxr = circshift(X,+1)-X;
			hl  = hypot(dxl,dyl);
			dxl = dxl./hl;
			dyr = dyl./hl;
			dyl = circshift(X,-1)-X;
			dyr = circshift(X,+1)-X;
			hr  = hypot(dxr,dyr);
			dxr = dxr./hr;
			dyr = dyr./hr;
			dx  = 0.5*dxl
			
			% displace vertex along halving direction	
			shp(jdx).X(fdx) = X+d*dx;
			shp(jdx).Y(fdx) = Y+d*dy;
		end % for jdx
	end % for idx
end % buffer

