% Fri  2 Dec 18:34:55 CET 2016
% Karl Kastner, Berlin
%
%% resample coordinates
%
function shp = resample_min(shp,dS_min)
	method = 'linear';
	seg_C = Shp.segment(shp);
	for idx=1:length(shp)
		seg = seg_C{idx};
		Xseg = [];
		Yseg = [];
		for jdx=1:size(seg,1)
			fdx = seg(jdx,1):seg(jdx,2);
			Xj  = cvec(shp(idx).X(fdx));
			Yj  = cvec(shp(idx).Y(fdx));
			dS  = hypot(diff(Xj),diff(Yj));
			S   = [0; cumsum(dS)];
			n   = ceil(dS/dS_min);
			%fdx = find(n>1);
			Si  = 0;
			for kdx=1:length(dS)
				Si = [Si, Si(end)+(1:n(kdx))/n(kdx)*dS(kdx)];
			end
			Si = Si';
			Xi = interp1(S,Xj,Si,method);
			Yi = interp1(S,Yj,Si,method);
			Xseg = [Xseg; Xi; NaN];
			Yseg = [Yseg; Yi; NaN];
		end % for jdx
		shp(idx).X = Xseg;
		shp(idx).Y = Yseg;
	end % for idx
end % resample_min
	

