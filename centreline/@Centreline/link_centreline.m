% Mo 8. Sep 19:30:48 CEST 2014
% Karl Kastner, Berlin

% TODO make this part of the centreline class
% for that, add a "section" column
function shp = link_centreline(shp,thresh)

	X = [shp.X];
	Y = [shp.Y];
	% 5 sigma threshold
	if (nargin < 2 || isempty(thresh))
		thresh2 = 5*quantile(sqrt((diff(X).^2+diff(Y).^2)),0.68);
	else
		thresh2 = thresh*thresh;
	end
	
	X = zeros(2*length(shp),1);
	Y = zeros(2*length(shp),1);
	for idx=1:length(shp)
		fdx = isfinite(shp(idx).X.*shp(idx).Y);
		shp(idx).X = shp(idx).X(fdx);
		shp(idx).Y = shp(idx).Y(fdx);
		% end points
		X(2*idx-1) = shp(idx).X(1);
		X(2*idx)   = shp(idx).X(end);
		Y(2*idx-1) = shp(idx).Y(1);
		Y(2*idx)   = shp(idx).Y(end);
		% get the direction of the end points
		dX(2*idx-1) = (shp(idx).X(2)-shp(idx).X(1));
		dX(2*idx)   = (shp(idx).X(end-1)-shp(idx).X(end));
		dY(2*idx-1) = (shp(idx).Y(2)-shp(idx).Y(1));
		dY(2*idx)   = (shp(idx).Y(end-1)-shp(idx).Y(end));
	end
	% normalise
	hyp = hypot(dX,dY); %sqrt(dX.*dX + dY.*dY);
	dX  = dX./hyp;
	dY  = dY./hyp;

	idx=1;
	last = length(shp);
	% for each end point
	while (idx <= 2*last)
		% get other end points in the vicinity of this end point
		d2 = (X(idx) - X(1:2*last)).^2 + (Y(idx) - Y(1:2*last)).^2;
		%N = [(1:last)'; (1:last)'];
		fdx = find(sqrt(d2) < thresh2);% & idx ~= N);
		if (length(fdx) > 1) %~isempty(fdx))
		% this is not a dangling node
		% search straightest continuation
		%fdx=[idx; fdx(:)];
%		angle = inf;
		cangle = -inf;
		for jdx=1:length(fdx)-1
		 for kdx=jdx+1:length(fdx)
		  % do not connect elements with themselves
		  if (fdx(jdx) ~= fdx(kdx) ...
		      && 2*fdx(jdx) ~= fdx(kdx) ...
		      &&   fdx(jdx) ~= 2*fdx(kdx))
		  % TODO, normalisation missing?
		  cangle_ = abs(dX(fdx(jdx))*dX(fdx(kdx))+dY(fdx(jdx))*dY(fdx(kdx)));
		  if (cangle_ > cangle)
			cangle = cangle_;
			m1 = fdx(jdx);
			m2 = fdx(kdx);
		  end % if cangle_ > cangle
		  end % if fdx ~= fdx
		 end % kdx
		end % jdx
		if (m1 == m2 || m1 == 2*m2 || m2==2*m1)
			error('here')
		end
		if (cangle > -inf)	
		% concatenate sections and update end points of first section
		if (mod(m1,2))
			% m1 is a start point
			n1 = (m1+1)/2;
			if (mod(m2,2))
				% the other point is also a start point
				n2 = (m2+1)/2;
				shp(n1).X = [shp(n1).X(end:-1:1) shp(n2).X];
				shp(n1).Y = [shp(n1).Y(end:-1:1) shp(n2).Y];
				X(2*n1-1)   = X(2*n1);
				Y(2*n1-1)   = Y(2*n1);
				dX(2*n1-1)  = dX(2*n1);
				dY(2*n1-1)  = dY(2*n1);
				X(2*n1)     = X(2*n2);
				Y(2*n1)     = Y(2*n2);
				dX(2*n1)    = dX(2*n2);
				dY(2*n1)    = dY(2*n2);
			else
				% the other point is an end point
				n2 = m2/2;
				shp(n1).X = [shp(n1).X(end:-1:1) shp(n2).X(end:-1:1)];
				shp(n1).Y = [shp(n1).Y(end:-1:1) shp(n2).Y(end:-1:1)];
				X(2*n1-1)   = X(2*n1); Y(2*n1-1) = Y(2*n1);
				dX(2*n1-1)   = dX(2*n1); dY(2*n1-1)   = dY(2*n1);
				X(2*n1) = X(2*n2-1);	Y(2*n1) = Y(2*n2-1);
				dX(2*n1) = dX(2*n2-1); dY(2*n1) = dY(2*n2-1);
			end
		else
			% this is an end point
			n1 = m1/2;
			if (mod(m2,2))
				% other point is start point
				n2 = (m2+1)/2;
				shp(n1).X = [shp(n1).X shp(n2).X];	
				shp(n1).Y = [shp(n1).Y shp(n2).Y];
				X(2*n1) = X(2*n2);	Y(2*n1) = Y(2*n2);
				dX(2*n1) = dX(2*n2); dY(2*n1) = dY(2*n2);
			else
				% other point is also an end point
				n2 = m2/2;
				shp(n1).X = [shp(n1).X shp(n2).X(end:-1:1)];
				shp(n1).Y = [shp(n1).Y shp(n2).Y(end:-1:1)];
				X(2*n1) = X(2*n2-1);	Y(2*n1) = Y(2*n2-1);
				dX(2*n1) = dX(2*n2-1); dY(2*n1) = dY(2*n2-1);
			end
		end % if mod n1, 2
		
		% remove point set m2 (overwrite with last and decrease last counter)
		shp(n2).X  = shp(last).X;
		shp(n2).Y  = shp(last).Y;
		X(2*n2-1)  = X(2*last-1);
		X(2*n2)    = X(2*last);
		Y(2*n2-1)  = Y(2*last-1);
		Y(2*n2)    = Y(2*last);
		dX(2*n2-1) = dX(2*last-1);
		dX(2*n2)   = dX(2*last);
		dY(2*n2-1) = dY(2*last-1);
		dY(2*n2)   = dY(2*last);
		last = last-1;
		else % not concatenated
		idx =idx+1;
		end
		else % if not concatenated
		idx = idx+1;
		end
	end % while idx
	% truncate
	shp = shp(1:last);
%	% squeeze
%not necessary
%	jdx = 0;
%	for idx=1:length(shp)
%		if (~isempty(shp(idx).X))
%			jdx=jdx+1;
%			shp(jdx).X = shp(idx).X;
%			shp(jdx).Y = shp(idx).Y;
%		end
%	end
%	% truncate
%	shp = shp(1:jdx);
end % link_centreline

