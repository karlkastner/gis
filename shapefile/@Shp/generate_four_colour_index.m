% Fri 16 Nov 14:24:59 CET 2018
%
%% unique colour-indices fpr poligons
%
function [shp,C] = generate_four_colour_index(shp,thresh)
	if (nargin() < 2)
		thresh = 1;
	end
	n = 0;
	C = sparse([],[],[],length(shp),length(shp),5*length(shp));
	
	for idx=1:length(shp)
	idx/length(shp)
	for jdx=idx+1:length(shp)
		dx = bsxfun(@minus,cvec(shp(idx).X),rvec(shp(jdx).X));
		dy = bsxfun(@minus,cvec(shp(idx).Y),rvec(shp(jdx).Y));
		C(idx,jdx) = any(any(dx.^2 + dy.^2 < thresh));
	end
	end
	C = C+C';
	ci    = ones(length(shp),1);

	% still a loop is required, for disjoint groups
	for idx=1:length(ci)
		ci = assign(ci,idx);
		if (ci(idx) == 1)
			idx
		pause
		end
	end
	% 5 to four
	ci = ci-1;
	ci = num2cell(ci);
	[shp.ci] = deal(ci{:});
		
	function ci = assign(ci,idx)
		if (ci(idx)<2)
		ci_ = [false,true(1,4)];
		% find neighbours
		fdx = find(C(:,idx));
		% mark colours of neighbours as used
		ci_(ci(fdx)) = false;
		% choose first unused color
		ci_ = find(ci_,1,'first');
		if (~isempty(ci_))
			ci(idx) = ci_;
		else
			ci(idx)=2;
			'error'
			idx
			%error('here');
			%error('here');
		end % ~isempty(ci)
		% assign neighbours
		for jdx=rvec(fdx)
			ci = assign(ci,jdx);
		end % for jdx
		end % ci(idx) < 2
	end % assign


end

