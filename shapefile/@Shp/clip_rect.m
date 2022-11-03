% Mi 28. Okt 10:34:26 CET 2015
% Karl Kastner, Berlin
%
%% rectrangular crop of the shapefile
%
function out = crop(shp,xmin,ymin,xmax,ymax)
	% TODO also crop other fields
	k = 0;
	out = struct('X',[],'Y',[]);
	f   = fieldnames(shp);
	for idx=1:length(f)
		out.(f{idx}) = [];
	end % for idx
	k = 1;
	for idx=1:length(shp)
%		k = k+1;
		X = cvec(shp(idx).X);
		Y = cvec(shp(idx).Y);
		fdx = (isnan(X) | isnan(Y) ...
                       | ( (X >= xmin & X <= xmax & Y >= ymin & Y <= ymax) ));
		fdx = find(diff([0 rvec(fdx) 0]));
		out(k).X = [];
		%struct('X',{},'Y',{});
		%f = {'X','Y'};
		n = length(shp(idx).X);
		for jdx=1:2:length(fdx)
			for kdx=1:length(f)
				if (length(shp(idx).(f{kdx})) == n)
					out(k).(f{kdx}) = [out(k).(f{kdx});
							   NaN;
							   cvec(shp(idx).(f{kdx})(fdx(jdx):fdx(jdx+1)-1))];
				%	out(k).X = X(fdx(idx):fdx(idx+1)-1);
				%	out(k).Y = Y(fdx(idx):fdx(idx+1)-1);
				end % if
			end % for kdx
		end % for idx
		if (0 ~= length(out(k).X))
%			out(k) = [];
			k = k+1;
		end % if
%		if (sum(fdx) > 0)
%			k = k+1;
%			out(k).X = X(fdx);
%			out(k).Y = Y(fdx);
%		end
	end % idx
	if (k == length(out))
		out(end) = [];
	end
end % crop

