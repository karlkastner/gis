% Fr 8. Jan 13:52:46 CET 2016
% Karl Kastner, Berlin
% D : distance between nodes
% S : index of shortest segment connecting the nodes
function [D Sid obj] = weighed_connection_matrix(obj,scaleflag)
	if (nargin() < 2 || isempty(scaleflag))
		scaleflag = false;
	end

	nn       = obj.segment.n_node;
	seg_id   = obj.segment.seg_id;
	seg_node = obj.segment.node;
	seg_S    = cvec(obj.seg_S);
	% TODO quick fix for equal end points
	% TODO, use length function
	d    = zeros(obj.segment.n,1);
	for idx=1:obj.segment.n
		%id = obj.segment.id{idx};
		l = sum(obj.segment.length(idx));
		%abs(seg_S(id(2)) - seg_S(id(end-1)));
		% avoid zero length, otherwise connection search may fail
		l = max(l,sqrt(eps));
		d(idx,1) = l;
	end
%	d = abs(seg_S(seg_id(:,1)) - seg_S(seg_id(:,2)));

	% scale
	if (scaleflag)
		w = zeros(obj.segment.n,1);
		for idx=1:obj.segment.n
			w(idx) = nanmedian(obj.width(obj.segment.id{idx}));
		end
		d = d./sqrt(w);
	end
	% avoid duplicates (will be added otherwise)
	buf(:,1) = min(seg_node(:,1),seg_node(:,2));
	buf(:,2) = max(seg_node(:,1),seg_node(:,2));
	buf(:,3) = d;
	buf(:,4) = (1:obj.segment.n);
	buf      = sortrows(buf);

	% remove longer dubplicate pathes around islands
	% otherwise length of dubplicate pathes will be added
%	fdx = [false; (0 == (diff(buf(:,1)).^2 + diff(buf(:,2)).^2))];

	fdx = [true;	  (buf(2:end,1) ~= buf(1:end-1,1) ) ...
			| (buf(2:end,2) ~= buf(1:end-1,2) ) ];
%	figure(2)
%	clf
	buf = buf(fdx,:);
%	for idx=1:length(buf) %fdx)
%		X = obj.segment.X(buf(idx,4));
%		Y = obj.segment.Y(buf(idx,4));
%		if (fdx(idx))
%			plot(X,Y,'-g');
%		else
%			plot(X,Y,'-r');
%		end
%		hold on
%	end
	
	%fdx = [false; (0 == (diff(buf(:,1)).^2 + diff(buf(:,2)).^2))];
	%buf = buf(~fdx,:);

	D   = sparse([buf(:,1); buf(:,2)],[buf(:,2); buf(:,1)],[buf(:,3);buf(:,3)],nn,nn);
	Sid = sparse([buf(:,1); buf(:,2)],[buf(:,2); buf(:,1)],[buf(:,4);buf(:,4)],nn,nn);
	%D = sparse([seg_node(:,1); seg_node(:,2)], ...
	%	   [seg_node(:,2); seg_node(:,1)], [d(:); d(:)], nn, nn);
end

