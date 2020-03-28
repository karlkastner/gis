% Wed 30 May 11:03:23 CEST 2018
function shp = scale(shp,s)
	if (length(s)<2)
		s(2)=s(1);
	end
	for idx=1:length(shp)
		shp(idx).X = s(1)*shp(idx).X;
		shp(idx).Y = s(2)*shp(idx).Y;
	end

end
