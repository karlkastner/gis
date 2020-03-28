% So 1. Nov 16:25:44 CET 2015
function out = split_jump(in,rmax)
	out = struct();
	k = 0;
	rmax2 = rmax*rmax;
	for idx=1:length(in)
		X = rvec(in(idx).X);
		Y = rvec(in(idx).Y);
		d2 = diff(X).^2 + diff(Y).^2;
		if (length(X) > 1)
		fdx = [d2>rmax2];
		fdx = [0 find(fdx) length(X)];
	%	find(fdx)
		for jdx=2:length(fdx)
%			if (fdx(jdx-1)-fdx(jdx) > 0)
				k = k+1;
				out(k).X = X(fdx(jdx-1)+1:fdx(jdx));
				out(k).Y = Y(fdx(jdx-1)+1:fdx(jdx));
%			end % if
		end % for jdx
		end
	end % for idx
end % shp_split_jump

