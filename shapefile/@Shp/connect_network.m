% Thu 25 Apr 09:18:36 CEST 2019
function [s,s_] = connect_networks(shp)

nmax = 4;
dmax = 0.004;

X   = [cvec([shp.X]);];
Y   = [cvec([shp.Y]);];
nx  = length(X);
xid = (1:nx)';

XX = [X(1:nx-1),X(2:nx)];
YY = [Y(1:nx-1),Y(2:nx)];
ii = [(1:nx-1)', (2:nx)'];

%fdx  = all(isfinite(XX),2);
%XX   = XX(fdx,:);
%YY   = YY(fdx,:);
%ii   = ii(fdx,:);
%s.X  = XX;
%s.Y  = YY;
%s.ii = ii;

tic
[id,d]  = knnsearch([X,Y],[X,Y],'K',nmax);
toc
% segment neighbours, is not second node at junctions
d(:,nmax+(1:2))  = 0;
id(:,nmax+1) = [(2:nx)';nx];
id(~isfinite(X(id(:,nmax+1))),nmax+1) = NaN;
id(:,nmax+2) = [1; (1:nx-1)'];
id(~isfinite(X(id(:,nmax+2))),nmax+2) = NaN;
fdx          = (d>dmax) | ~isfinite(id);
% fdx = isnan(id) || fdx;
id(fdx) = nx+1;

% neighbour distance and neighbour index
%s.nd  = [d(s.ii(:,1),:),d(s.ii(:,2),:)];
ni    = id; %[id(ii(:,1),:),id(ii(:,2),:)];
%fdx   = isnan(s.ni);
%s.ni(fdx) = nx;
%s.ii(end+1) =

% own index as start index
sid  = (1:nx+1)';
ni(nx+1,:) = nx+1;
%s.ii(:,1);
% while change
while (true)
	% get smallest neighbour index of all neighbours
	% and take over the smallest index
	sid_ = sid;
	sid__ = [sid,sid(ni)];
%sid__(1:20,:)
%pause
	sid  = min([sid,sid(ni)],[],2);
	sd = sum(sid ~= sid_)
	if (0 == sd)
		break;
	end
end
sid = sid(1:nx);
%s.sid = sid;
s_.X = X;
s_.Y = Y;
s_.sid = sid;

% recover segments
X   = [X(1:end-1),X(2:end)];
Y   = [Y(1:end-1),Y(2:end)];
sid = [sid(1:end-1),sid(2:end)];
fdx = all(isfinite(X),2);
X   = X(fdx,:);
Y   = Y(fdx,:);
sid = sid(fdx,:);
s.X = X;
s.Y = Y;
s.sid = sid;


%[sid,fdx] = sort(sid);
%s.ii = s.ii(fdx,:);

%ss = struct();
%% TODO make unique
%% attach segments to 
%for idx=1:size(s.ii)
%	ss(sid(idx)).id(end+1:end+3) = [s.ii(id),nx+1];
%end
%for idx=1:size(ss)
%	ss(idx).X = X(ss(idx).id);
%	ss(idx).Y = Y(ss(idx).id);
%end

% segments
%s.X = zeros(length(X),2);
%s.Y = zeros(length(X),2);
%n = 0;
%for idx=2:length(X)
%	n=n+1;
%	if (isfinite(X(idx)))
%		n = n+1;
%		s.X(n,:) = [X(idx-1),X(idx)];
%		s.Y(n,:) = [Y(idx-1),Y(idx)];
%	end
%end
%s.X = s.X(1:n,:);
%s.Y = s.Y(1:n,:);

%%XY = [cvec(shp.X),shp.;
%Y = shp.Y;
%
%[id,d] = knnsearch(
%
%% knnsearch for nearest n neighbours
%% for each segment
%for idx
%	% if not yet parsed
%	nr = nr+1;
%	parse(idx,nr) 
%end
%
%function parse(id,nr)
%	r{nr}(end+1) = id;
%	for each end point
%	for each neighbour
%		if closer than minimum distance
%			parse(jdx,nr);
%		end
%	end
%	end
%end
%
end % connect_networK
