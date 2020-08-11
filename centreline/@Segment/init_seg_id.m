% Sa 21. Nov 14:23:33 CET 2015

function [seg_id obj] = init_seg_id(obj)
	% first and last
	seg_id = [cvec(cellfun(@(x) x(1) , obj.id)) cvec(cellfun(@(x) x(end) , obj.id))];

	% second and last but one
	seg_id_ = [cvec(cellfun(@(x) x(2) , obj.id)) cvec(cellfun(@(x) x(end-1) , obj.id))];
	obj.seg_id  = seg_id;
	obj.seg_id_ = seg_id_;
end

