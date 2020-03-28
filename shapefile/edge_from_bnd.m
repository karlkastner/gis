% 2016-02-09 20:43:00.596356660 +0100
% Karl Kastner, Berlin

function [X Y E] = edge_from_bnd(X,Y)
	X(end+1) = NaN;
	n1 = 1;
	E = [];
	for idx=2:length(X)
		if (~isnan(X(idx)) && ~isnan(X(idx-1)))
			E(end+1,:) = [idx-1,idx];
		end
		if (isnan(X(idx)) && ~isnan(X(idx-1)))
			E(end+1,:) = [n1,idx-1];
		end
		if (isnan(X(idx-1)) && ~isnan(X(idx)))
			n1 = idx;	
		end
	end
	fdx = isfinite(X);
	X = X(fdx);
	Y = Y(fdx);
	id = cumsum(fdx);
	E = id(E);
%	% last edge
%	n = length(X);
%	if (~isnan(X(n)))
%		E(end+1,:) = [n1 n];
%	end
end

