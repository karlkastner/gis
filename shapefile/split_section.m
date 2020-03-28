% Sat Jun 28 14:42:07 WIB 2014

function s = split_section(s,id,ida,idb,xa,ya,xb,yb)
	if (ida < idb)
		xa_ = xa;
		ya_ = ya;
		xb_ = xb;
		yb_ = yb;
	else
		xa_ = xb;
		ya_ = yb;
		xb_ = xa;
		yb_ = ya;
	end

	ida_ = min(ida,idb);
	idb_ = max(ida,idb);
	n = length(s)+1;

	% add tail as new section
	s(n).X = [xb_ s(id).X(idb_:end)];
	s(n).Y = [yb_ s(id).Y(idb_:end)];
	if (~isnan(s(n).X(end)))
		s(n).X(end+1) = NaN;
		s(n).Y(end+1) = NaN;
	end
	% remove mid section
	s(id).X(ida_:end) = []; %+(1:length(s(n).X))) = [];
	s(id).Y(ida_:end) = []; %+(1:length(s(n).Y))) = [];
	if (~isempty(xa_))
		s(id).X(end+1) = xa_;
		s(id).Y(end+1) = ya_;
	end
	s(id).X(end+1) = NaN;
	s(id).Y(end+1) = NaN;
%clf
%plot(s(id).X,s(id).Y,'.-')
%pause
%pause 

	% full stop
%	s(id).X(1) = NaN;
%	s(id).Y(1) = NaN;
end

%
