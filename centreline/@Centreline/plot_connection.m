% 2016-01-04 10:41:39.581938103 +0100
function obj = plot_connection(obj)
	seg_id = obj.segment.seg_id;
	% assumption that the segments are not circles
%	X = X(seg_id);
%	Y = Y(seg_id);
%	X(2,:) = X(seg_id(2,:));
%	Y(2,:) = Y(seg_id(2,:));

	Xc = cellfun(@(id) mean(obj.X(id)), obj.segment.id);
	Yc = cellfun(@(id) mean(obj.Y(id)), obj.segment.id);
	disp([median(Xc),median(Yc)])
	plot(Xc,Yc,'.');
	text(Xc,Yc,num2str(obj.segment.total_length))
end

