% 2015-11-10 12:43:50.029202481 +0100
% Karl Kastner, Berlin

% TODO do not write duplicate points ?
function out = link_lines(shp,d_max)
	if (nargin()<2)
		d_max = 1e2;
	end
	shp = Shp.split_nan(shp);

	n  = length(shp);
	XY = zeros(2*n,2);
	for idx=1:n
		X = shp(idx).X;
		Y = shp(idx).Y;
		X = rvec(X(isfinite(X)));
		Y = rvec(Y(isfinite(Y)));
%		if (X(1) == X(end) && Y(1) == Y(end))
%			'honk'
%			X = X(1:end-1);
%			Y = Y(1:end-1);
%		end
		in(idx).X = X;
		in(idx).Y = Y;
		XY(2*idx-1,1) = X(1);
		XY(2*idx-1,2) = Y(1);
		XY(2*idx,1)   = X(end);
		XY(2*idx,2)   = Y(end);
	end
	out = struct('X',{},'Y',{});

	% while there are unconnected endpoints
	while (size(XY,1) > 2)
		% update start point
		XY(1,:) = [in(1).X(1), in(1).Y(1)];
		% update end point
		XY(2,:) = [in(1).X(end), in(1).Y(end)];

		% search closest end point of other segments to first end point of this segment
		d        = hypot(XY(3:end,1) - XY(1,1), ...
				 XY(3:end,2) - XY(1,2));
		[md(1), mdx(1)] = min(d);
		mdx(1) = mdx(1)+2;
		m(1)   = ceil(mdx(1)/2);

%		% check if this is a closed loop
%		if (2 == mdx(1) )
%			if ( md(1) < d_max)
%			% close loop
%			if (   in(1).X(1) ~= in(1).X(end) ...
%			    || in(1).Y(1) ~= in(1).Y(end) ... 
%			   )
%			    in(1).X(end+1) = in(1).X(1);
%			    in(1).Y(end+1) = in(1).Y(1);
%			end
%			end % md < d_max
%			% directly write to output
%			out(end+1) = in(1);
%		else
		% search closest other end point to second end point
		d        = hypot(XY(3:end,1) - XY(2,1), ...
				 XY(3:end,2) - XY(2,2));
		[md(2), mdx(2)] = min(d);
		mdx(2) = mdx(2)+2;
		m(2)   = ceil(mdx(2)/2);

		if (md(1) <= md(2))
			% first point of first segiment is closer, prepend
			mdx = mdx(1);
			m   = m(1);

			% check if distance too far / unconnected
			if (md(1) > d_max)
				% push to output
				m = 1;
				out(end+1) = in(1);
				%Shp.plot(out);
				%pause(0.1);
				%drawnow
			else

			% concatenate
			% test if second end is start or end point
			if (0 == mod(mdx,2))
				% other point is at end, simply concatenate
				in(1).X = [in(m).X, in(1).X];
				in(1).Y = [in(m).Y, in(1).Y];
			else
				% other point is at start, concatenate reordered
				in(1).X = [fliplr(in(m).X), in(1).X];
				in(1).Y = [fliplr(in(m).Y), in(1).Y];
			end
			end % else of md1 > d_max
		else
			% end point of first segment is closer, concatenate to end
			mdx = mdx(2);
			m   = m(2);
			% concatenate
			% test if second end is start or end point
			if (0 == mod(mdx,2))
				% other point is at end, reorder
				in(1).X = [in(1).X, fliplr(in(m).X)];
				in(1).Y = [in(1).Y, fliplr(in(m).Y)];
			else
				% other point is at start, concatenate
				in(1).X = [in(1).X, in(m).X];
				in(1).Y = [in(1).Y, in(m).Y];
			end
		end % else of md1 < md2
%		end % of else loop
		% delete start and end point of merged segment from input
		%XY([m,n+m],:) = [];
		printf('deleting %d\n',m)
		XY(2*m-1:2*m,:) = [];
		in(m) = [];

%		clf
%		Shp.plot(in)
%		pause
	end % while
	out(end+1) = in;
end % function

