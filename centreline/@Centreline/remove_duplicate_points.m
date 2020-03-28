% Sa 21. Nov 11:43:56 CET 2015
% Karl Kastner, Berlin

function [X Y E] = remove_duplicates(X,Y,E)
	% remove duplicate points
	[XY ia ic] = unique([X Y],'rows');
	X = XY(:,1);
	Y = XY(:,2);
	% update indices for all segments
	%for idx=1:length(E)
	for idx=1:size(E,2)
		E(:,idx) = ic(E(:,idx));
		% sucessive points may now be identical, skip them
		% TODO, this should only apply to identical points in one row
%		E{idx} = unique(seg{idx},'stable');
	end
end % remove_duplicates

