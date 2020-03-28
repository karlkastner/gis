% Thu Nov 20 12:47:59 CET 2014
% Karl Kastner, Berlin

% resample the resolution
% TODO this should be part of segment
% TODO recomputation of S may be necessary, as Si does not exactly coincide with S
% this can be avoided (reduced) by choosing for the integration and
% resampling the same polynomial order
% TODO use function resample_2d
function obj = resample(obj, d_res, Ri, p)
%	d2_res = d_res*d_res;

	% fetch
	S  = obj.seg_S;
	XY = [obj.X, obj.Y];
	seg_id = obj.segment.seg_id;
	S0 = obj.seg_S0;
	Si   = [];
	XYi  = [];
	segi = [];
	n    = 0; 
	% now there is the problem that end points are multiplied
	for idx=1:size(seg_id,1)
		% old indices
		% TODO bad, bad, bad, this should be segment.id(idx)
		fdx  = seg_id(idx,1):seg_id(idx,2);
		% target coordinate
		Si_ = S0(idx,1):d_res:S0(idx,2);
		% (S(seg_id(idx,1)):d_res:S(seg_id(idx,2)))';
		Si  = [Si;Si_];
		% new indices
		ni   = length(Si_);
		if (ni > 0)
			fdxi = n+1:n+ni;
			% interpolate XY
			XYi(fdxi,:) = interp1_smooth([S0(idx,1); S(fdx(2:end-1)); S0(idx,2)], ...
								XY(fdx,:),Si(fdxi),Ri,p);
			% update segment forward and inverse index
			segi(fdxi)    = idx;
			seg_id(idx,:) = [n+1,n+ni];
			n=n+ni;
		else
			seg_id(idx,:) = 0;
		end
	end

	% write back
	obj.seg_S = Si;
	obj.X = XYi(:,1);
	obj.Y = XYi(:,2);

	% TODO the centreline should not be referred to by seg_id (ambiguous end points)
	% seg_id should be removed from the centreline class
	obj.segment.seg_id = seg_id;

	obj.segment.rid = segi;
	id = cell(size(seg_id,1));
	for idx=1:size(seg_id,1)
		id{idx} = seg_id(1):seg_id(2);
	end
	obj.segment.id = id;
%	obj.seg = segi;
%	obj.seg_id = seg_id;

%	Si            = (obj.S(1):d_res:obj.S(end))';
%	[XY dXY ddXY] = interp1_smooth(obj.S,[obj.X obj.Y],Si,Ri,p);
%	obj.X      = XY(:,1);
%	obj.Y      = XY(:,2);
%	obj.S      = Si;
	
%		% convert to s coordinate
%		dx = [0; diff(obj.X)];
%		dy = [0; diff(obj.Y)];
%		ds = sqrt(dx.*dx + dy.*dy);
%		obj.S  = cumsum(ds);
%		% sparsification
%		fdx = false(size(obj.X));
%		fdx(1) = true;
%		S_last = 0;
%		if (d_res > 0)
%			for jdx=2:end(obj.X)
%				if (S-S_last > d_res)
%					fdx(idx) = true;
%					S_last = S;
%				end
%			end
%		end
%		% truncate vectors
%		obj.S = obj.S(fdx);
%		obj.X = obj.X(fdx);
%		obj.Y = obj.Y(fdx);

%	jdx = 1;
%	obj.S = zeros(size(obj.X),class(obj.X));
%	for idx=2:length(obj.X)
%		d2 = ( (obj.X(idx)-obj.X(jdx))^2 ...
 %                    + (obj.Y(idx)-obj.Y(jdx))^2 );
%		if (d2 > d2_res)
%			obj.S(jdx+1) = obj.S(jdx) + sqrt(d2);
%			obj.X(jdx+1) = obj.X(idx);
%			obj.Y(jdx+1) = obj.Y(idx);
%			jdx=jdx+1;
%		end
%	end % for idx

end % resample()

