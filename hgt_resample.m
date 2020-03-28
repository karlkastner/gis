% Fri  9 Sep 13:22:07 CEST 2016
function hgt = hgt_resample(hgt,skip)
	for idx=1:length(hgt)
		hgt(idx).z = hgt(idx).z(1:skip:end,1:skip:end);
%		size(hgt(idx).X)
		limits(hgt.X(:))
		hgt(idx).X = hgt(idx).X(1:skip:end,1:skip:end);
		limits(hgt.X(:))
%		size(hgt(idx).X)
		hgt(idx).Y = hgt(idx).Y(1:skip:end,1:skip:end);
	end
end
