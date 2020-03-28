% Fri  9 Sep 10:58:42 CEST 2016
function hgt_plot(hgt)
	h = ishold();
	for idx=1:length(hgt)
		%imagesc(hgt(idx).X,hgt(idx).Y,hgt(idx).z);
		%surface(hgt(idx).X,hgt(idx).Y,hgt(idx).z,'edgecolor','none');
		surf(hgt(idx).X,hgt(idx).Y,0.*hgt(idx).z,hgt(idx).z,'edgecolor','none');
%		[limits(hgt(idx).X(:)) limits(hgt(idx).Y(:))]
%		[limits(hgt(idx).z(:)) limits(hgt(idx).z(:))]
%		nansum(abs(hgt(idx).z-hgt(idx).z)
%		imagesc(hgt(idx).z)
%		'honk'
%		axis auto
		hold on
	end
	if (~h)
		hold off;
	end
end

