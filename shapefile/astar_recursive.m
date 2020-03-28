% Fri  5 Oct 15:38:10 CEST 2018
%
%% astar path finding algorithm
% longest, second longest ...
function [shp,shp_,x,y,id,l_,passed] = astar_recursive(val,i0,j0) %,p)
	% max increase
	qq = 1.05; %.00625;
	% TODO quick fix
	sc   = 100;
	val  = round(sc*val);
	pred = zeros(size(val));
	pred(i0,j0) = sub2ind(size(val),i0,j0);

	% stopping criteria
	n_max = 2e3;
	v_min = 0.0001*val(i0,j0);

	% mouth to source: value must decrease
	x = [];
	y = [];
	passed = false(size(val));
%	q = javaObject('java.util.PriorityQueue');
	q = java.util.PriorityQueue;

	id = xyv2id(i0,j0,val(i0,j0));
	q.add(id);
	l = NaN(size(val));
	l(i0,j0) = 0;

	while (~q.isEmpty)
		% pop the head with highest value
		id            = q.remove();
		[i0,j0,v0]    = id2xyv(id);
		passed(i0,j0) = true;
		
		% concatenate to path
		x=[x;i0]; 
		y=[y;j0];

		change = false; 
		i0_ = i0;
		j0_ = j0;
		%v0 = -inf; % 0.5*val(i0,j0);
		% for all neightbours
		for dx=-1:1
		 for dy=-1:1
			% push neighbours onto the stack
			x_ = i0_+dx;
			y_ = j0_+dy;
			if (x_ > 0 && y_ > 0 && x_ < size(val,1) && y_<size(val,2))
			if (~passed(x_,y_))
				v_ = val(x_,y_);
				if (v_ <= qq*v0) % reqire decreasing
				if (v_ > v_min)
				id = xyv2id(x_,y_,v_);
				q.add(id);
				l(x_,y_) = l(i0,j0) + hypot(dx,dy);
				pred(x_,y_) = sub2ind(size(val),i0,j0);
%				if(val(i0_+dx,j0_+dy)>v0)
%					% force descending
%					if (val(i0_+dx,j0_+dy) <= val(i0_,j0_))
%						i0 = i0_+dx;
%						j0 = j0_+dy;
%						v0 = val(i0,j0);
%						change = true;
%					end
%				end
				end
				end
			end % if
			end
		 end % dy
		end % dx
		%if (~change)
		if (length(x) > n_max)
			break;
		end
		
	end

	id      = sub2ind(size(val),x,y);
	% segments
	id(:,2) = pred(id);
	l_      = l(id);

	% build network backwards
	id_ = id(:,1);
	%id1 = 0;
	id2 = 0;	
	%c={};
	c  = zeros(2,1);
	l2 = zeros(2,1);
	%shp_ = struct();
	% TODO inefficient, put used one to end or use heap again
	while (~isempty(id_))
		% next sub-river with maximum length
		[mv,mid] = max(l(id_));
		mid      = id_(mid);
		% stop if no river segments left
		if (l(id_) <= 0)
			break;
		end
		while (1)
			% append to chain
			id2    = id2+1;
			c(id2) = mid;
			% break if stem or mouth of stem reached
			if (l(mid) <= 0)
				l2(id2) = -l(mid);
				break;
			else
				l2(id2) = l(mid);
				% mark as passed
				l(mid) = -abs(l(mid));
				% step downstream
				mid = pred(mid);
			end
		end % while
		% terminate reach
		id2     = id2+1;
		c(id2)  = NaN; 
		l2(id2) = NaN;
	end
	c  = [flipud(c(1:end-1));NaN];
	l2 = [flipud(l2(1:end-1));NaN];
	shp           = struct();
	shp.ij        = c;
	[shp.i,shp.j] = ind2sub(size(val),c); 
	shp.l         = NaN(size(c));
	shp.l         = l2;
	fdx           = isfinite(c);
	shp.Z	      = NaN(size(c));
	shp.Z(fdx)    = val(c(fdx))/sc;

function id = xyv2id(x,y,v)
	id = x + y*1000 + v*1000^2;
	id = -id;
end

function [x,y,v] = id2xyv(id)
	id = -id;
	x = mod(id,1000);
	y = mod(fix(id/1000),1000);
	v = fix(id/1000^2);
end

end
