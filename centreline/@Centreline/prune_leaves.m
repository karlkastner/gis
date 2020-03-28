% Do 7. Jan 18:08:30 CET 2016
% Karl Kastner, Berlin

% px,py: leave with end point closest to px and py are protected
% note that px anx py must be given, due to the recursive implementation
function obj = prune_leaves(obj,px,py)
	if (nargin()<2)
		px = [];
	end

	% connectivity matrices of segments
	[A, A1, A2] = obj.segment.connectivity_matrix();
	sdx = true(obj.segment.n,1);

	% create mask for protected segments
	pdx = true(obj.segment.n,1);
	for idx=1:length(px)
		pdxi = obj.find_nearest_segment(px(idx),py(idx));
		pdx(pdxi) = false;
	end

	n = 0;
	o = ones(size(A1,1),1);
	while (true)
		% leaves are segments not connected at either end
		% A1 and A2 are not symmetric, rows have to be summed
		%sdx = (min(sum(A1,2),sum(A2,2)) < 2);
		sdx = (min(A1*o,A2*o) < 2);	

		% apply mask for protected segments
		sdx = (sdx & pdx);

		% find leaves (sections with only one or no other connecting section)
		% stop if all leaves are found
		n_ = sum(sdx);
		if (n_ == n)
			break;
		end
		n = n_;

		% remove connections to segments that are leaves
		o(sdx) = 0;
		%A1(sdx,:) = 0;
		%A1(:,sdx) = 0;
		%A2(sdx,:) = 0;
		%A2(:,sdx) = 0;
	end % while true

	obj.prune(~sdx);
end % prune_leaves

