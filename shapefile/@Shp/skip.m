% Thu 26 May 10:16:05 CEST 2016
% Karl Kastner, Berlin
function out = skip(shp,sk)
	out = [];
	seg_C = Shp.segment(shp);
	for idx=1:length(shp)
		X   = cvec(shp(idx).X);
		Y   = cvec(shp(idx).Y);
		X_ = []
		Y_ = [];
		seg = seg_C{idx};
		for jdx=1:size(seg,1)
			% todo keep last
			X_ = [X_; X(seg(jdx,1):sk:seg(jdx,2)-1); X(seg(jdx,2)); NaN];
			Y_ = [Y_; Y(seg(jdx,1):sk:seg(jdx,2)-1); Y(seg(jdx,2)); NaN];
		end
		out(idx).X = X_;
		out(idx).Y = Y_;
	end
end

