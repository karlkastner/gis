% Fri  9 Sep 10:49:57 CEST 2016
function [hgt]=read_hgt_all(folder)
	a=dir(folder);
	A = [];
	hgt = [];
	k = 0;
	for idx=1:length(a)
		name=a(idx).name;
		if ((length(name)>4) && strcmp(lower(name(end-3:end)),'.hgt'))
			k = k+1;
			hgt(k).name =name;
			[z lon lat] = hgt_read([folder,filesep,name]);
			hgt(k).z = z;
			hgt(k).lat = lat;
			hgt(k).lon = lon;

			lat2 = repmat(cvec(lat),1,length(lon));
			lon2 = repmat(rvec(lon),length(lat),1);
			[X Y] = latlon2utm(lat2,lon2,'49M');
			hgt(k).X = X;
%		if (max(Y(:)) > 1e6)
%			Y=Y-
			
			hgt(k).Y = Y;

%			X(idx) = x(1);
%			Y(idx) = y(1);
%			dx = x(2)-x(1);
%			dy = y(2)-y(1);
%			id = round(x/dx+180/dx);
%			jd = round(y/dy+90/dy);
%			A(id,jd) = z;		
		end
	end
	[YX] = sortrows([Y X]);
end

