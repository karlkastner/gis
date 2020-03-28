% Sa 21. Nov 11:48:32 CET 2015
% Karl Kastner, Berlin

function [seg, junction] = connect_graph(X, Y, E)
%	abstol = 1e-7;

	ne  = size(E,1);
	np = length(X);

	% number of neighbours
	nn = zeros(np,1);
	% neighbour indices
	N = zeros(np,3);

	for idx=1:ne
		% connect points
		nn(E(idx,1))             = nn(E(idx,1))+1;
		N(E(idx,1),nn(E(idx,1))) = E(idx,2);
		nn(E(idx,2))             = nn(E(idx,2))+1;
		N(E(idx,2),nn(E(idx,2))) = E(idx,1);
	end % length cx

	% P indicates already processed segments
	P   = false(np,1);
	ns  = 0;
	seg = {};
	junction = {};
	% only for end points
	sid = cell(np,1);
	for idx=1:np
		% if this is an end point
		if (is_end_point(nn(idx)))
			% for each end point, start a new section and procede until other end point
			for jdx=1:nn(idx)
				next    = N(idx,jdx);
				% avoid that segments are processed twice
				if (~P(next))
				ns      = ns+1;
				sid{idx} = [sid{idx} ns];
				old     = idx;
				seg{ns} = [idx next];
				while (~is_end_point(nn(next)))
					if (old == N(next,1))
						old  = next;
						next = N(next,2);
					else
						old  = next;
						next = N(next,1);
					end
					seg{ns}(end+1) = next;
				end % while end of loop is not reached
				sid{next} = [sid{next}, ns];
				% mark first point into segment as processed
				P(old) = true;
				end
			end % for all connecting neighbours
		end % if this is an end point
		% if this is a junction
		if (is_junction(nn(idx)))
			junction(end+1).pid  = idx;
		end
	end % for idx
	for idx=1:length(junction)
		junction(idx).sid  =  sid{junction(idx).pid};
	end
end % connect graph

function is = is_junction(n)
	is = (n > 2);
end

% a point is an end point if it has 0 or more than 1 neighbour
function is = is_end_point(n)
	is = (n ~= 2);
end

