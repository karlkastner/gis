% Do 7. Jan 18:15:50 CET 2016
% Karl Kastner, Berlin

function [A, A1, A2] = connectivity_matrix(obj)
	n = obj.n;
%	seg_id = cellfun(@(x) [x(1) x(end)], obj.id);
	seg_id = obj.seg_id;
	buf1 = [];
	buf2 = [];
	for idx = 1:n
		% connection at first end
		fdx1 = find( ...
                         seg_id(idx,1) == seg_id(:,1) ...
                       | seg_id(idx,1) == seg_id(:,2) );
		buf1 = [buf1; [idx*ones(length(fdx1),1), fdx1]];
		% connection at other end
		fdx2 = find( ...
                         seg_id(idx,2) == seg_id(:,1) ...
                       | seg_id(idx,2) == seg_id(:,2) );
		buf2 = [buf2; [idx*ones(length(fdx2),1), fdx2]];
	end
	A1 = sparse(buf1(:,1),buf1(:,2),ones(size(buf1,1),1),n,n);
	A2 = sparse(buf2(:,1),buf2(:,2),ones(size(buf2,1),1),n,n);
	% combined conection matrix
	A = A1 | A2;
end % connectivity_matrix

