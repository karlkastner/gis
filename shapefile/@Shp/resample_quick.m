% 2015-11-28 13:16:30.162675799 +0100

function out = resample_quick(shp,h)
	out = [];
        seg_C = Shp.segment(shp);
	field_C = fieldnames(shp);

	for idx=1:length(shp)
		X   = cvec(shp(idx).X);
		Y   = cvec(shp(idx).Y);
		seg = seg_C{idx};
		out(idx).X = [];
		out(idx).Y = [];
		% copy scalar field
		for jdx=1:length(field_C)
		switch (field_C{jdx})
		case {'X','Y'}
			% resampled separately below
		otherwise
			out(idx).(field_C{jdx}) = shp(idx).(field_C{jdx});
		end % switch field
		end % for jdx


	for jdx=1:size(seg,1)

if (0)
	fdx = seg(jdx,1):seg(jdx,2);
        S   = [0; cumsum(hypot(diff(X(fdx)),diff(Y(fdx))))];
	% make unique
	% TODO, quick hack
	S   = S + 1e-7*(1:length(S))';
	n   = round(S(end)/h);
	% for polygons, not closed
	Si  = S(end)*(0:n-1)'/n;
	Xi  = cvec(interp1(S,X(fdx),Si));
	Yi  = cvec(interp1(S,Y(fdx),Si));
end
	% interpolation does not guarantee minimum edge length
	% so interpolated elements that are too close are skipped
	% skipping elements
	if (seg(jdx,2)>seg(jdx,1))
		id   = zeros(seg(jdx,2)-seg(jdx,1)+1,1);
		n = 1;
		id(1) = seg(jdx,1);
		for kdx=seg(jdx,1)+1:seg(jdx,2)
			if (hypot(X(kdx)-X(id(n)),Y(kdx)-Y(id(n))) >= h)
				n = n+1;
				id(n) = kdx;
			end
		end
		% ensure that last element is not too close to the first
		if (hypot(X(id(1))-X(id(n)),Y(id(1))-Y(id(n))))
			n=n-1;
		end
		Xi = cvec(X(id(1:n)));
		Yi = cvec(Y(id(1:n)));
		out(idx).X = [out(idx).X; NaN; Xi];
		out(idx).Y = [out(idx).Y; NaN; Yi];
	end
	end % for jdx
	end % for idx
end

