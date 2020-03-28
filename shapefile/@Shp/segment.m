% Mi 28. Okt 09:44:35 CET 2015
% Karl Kastner, Berlin

% separate disjoint sections of polygons and lines
function seg = segment(shp)
	for idx=1:length(shp)
		X = cvec(shp(idx).X);
		Y = cvec(shp(idx).Y);
%		fdx = find(isnan(X.*Y));
%		seg{idx} = [ [1; fdx+1], [fdx-1; length(X)]];
		fdx = [0; find(isnan(X.*Y)); length(X)+1];
		C = [];
		for jdx=1:length(fdx)-1
			%seg{idx} = [ [1; fdx+1], [fdx-1; length(X)]];
			if (fdx(jdx)+1 < fdx(jdx+1)-1)
				C(end+1,:) = [fdx(jdx)+1, fdx(jdx+1)-1];
			end
		end
		seg{idx} = C;
		%section_C(1,1) = 1;
		%for idx=1:length(fdx)
		%	section_C(  idx,2) = fdx(idx)-1;
		%	section_C(idx+1,1) = fdx(idx)+1;
		%end
		%section_C(end,2) = length(X);
	end % for idx 
end % segment

