% Tue Nov 18 17:32:04 CET 2014
% Karl Kastner, Berlin

% TODO rename into add_bankline

function [bank left right width obj] = channel_planimetry(obj, bank, Ri_bank, p_bank, iflag)

	if (nargin() < 3 | isempty(Ri_bank))
		Ri_bank = 500; % m 
	end
	if (nargin() < 4 | isempty(p_bank))
		p_bank = 4;
	end
	if (nargin() < 5)
		iflag = 0;
	end

	% remove invalid points
	fdx    = isfinite(bank.X.*bank.Y);
	bank.X = bank.X(fdx);
	bank.Y = bank.Y(fdx);


	% remove duplicate points
%	[XY ia] = unique([bank.X bank.Y],'rows','stable');
%	bank.X = bank.X(ia,1);
%	bank.Y = bank.Y(ia,1);

	[bank.S bank.N pid sid] = obj.xy2sn(bank.X,bank.Y);

	if (0)
		obj.left_  = NaN(obj.n,1);
		obj.right_ = NaN(obj.n,1);
		seg_id = obj.segment.seg_id;
		% for each segment
		for idx=1:size(seg_id,1)
			% inner points of segment
			cdx = seg_id(idx,1)+1:seg_id(idx,2)-1;
			S   = obj.seg_S(cdx);
			%S = [obj.seg_S0(idx,1); obj.seg_S(cdx(2:end)
			% left (include zero for schematic zero-width channels)
			bdx = find((sid==idx) & bank.N <= 0);
			if (isempty(bdx))
				obj.left_(cdx)  = NaN;
			else
				obj.left_(cdx) = interp1(bank.S(bdx),bank.N(bdx),S);
			end
			% right
			bdx = find((sid==idx) & bank.N >= 0);
			if (isempty(bdx))
				obj.right_(cdx)  = NaN;
			else
				obj.right_(cdx) = interp1(bank.S(bdx),bank.N(bdx),S);
			end
		end
	else
		% TODO this is only zero order accurate
		[id dis] = knnsearch([bank.X,bank.Y],[obj.X,obj.Y]);
		obj.left_  = -dis;
		obj.right_ = +dis;
%	clf
%	skip = 100;
%	X = obj.X;
%	Y = obj.Y;
%		scatter3(X(1:skip:end),Y(1:skip:end),dis(1:skip:end),[],dis(1:skip:end));
%	view(0,90)
%	pause
	end
	obj.width_ = obj.right_ - obj.left_;

if (0)
	% split up in left and right bank
	fdx     = bank.N > 0;
	left.X  = bank.X(fdx);
	left.Y  = bank.Y(fdx);
	left.S  = bank.S(fdx);
	left.N  = bank.N(fdx);
	left.id = id(fdx);

	fdx      = bank.N < 0;
	right.X  = bank.X(fdx);
	right.Y  = bank.Y(fdx);
	right.S  = bank.S(fdx);
	right.N  = bank.N(fdx);
	right.id = id(fdx);

	% This is only for the return arguments
	% internally only n-coordinates of banks are kept
	% TODO S should be interpolated to bank for return and not the other way around
	if (iflag)
		ifunc = @(X,V,Xi) interp1_smooth(X,V,Xi,Ri_bank,p_bank);
	else
		ifunc = @(X,V,Xi) interp1(X,V,Xi,'cubic');
	end

if (true)
	% assign left and right bank where bank line is defined
	% TODO, this is only first order accurage
	right_           =  NaN(obj.n,1);
	right_(right.id) = right.N;

	left_            = NaN(obj.n,1);
	left_(left.id)   = left.N;

	% interpolate (TODO limit distance)
	seg_id = obj.seg_id;
	for idx=1:size(seg_id,1)
		fdx = seg_id(idx,1):seg_id(idx,2);
		S   = [obj.seg_S0(idx,1); obj.seg_S(fdx); obj.seg_S0(idx,2)];
		
		
	end

	% write back
	obj.left_  = left_;
	obj.right_ = right_;
else
	[S id]  = unique(left.S,'rows','stable');
	left.N  = ifunc(left.S(id),left.N(id),obj.S);
	left.X  = ifunc(left.S(id),left.X(id),obj.S);
	left.Y  = ifunc(left.S(id),left.Y(id),obj.S);
	left.S  = obj.S;

	[S id] = unique(right.S,'rows','stable');
	right.N = ifunc(right.S(id),right.N(id),obj.S);
	right.X = ifunc(right.S(id),right.X(id),obj.S);
	right.Y = ifunc(right.S(id),right.Y(id),obj.S);
	right.S = obj.S; 

	% write back
	obj.left  = left.N;
	obj.right = right.N;
end
end	
	% river width
	%W = sqrt( (left.X - right.X).^2 + (left.Y - right.Y).^2 );
	%width = abs(left.N-right.N);
	%for idx=1:length(S)
		%D2 = (left.S - S(idx)).^2;
		%[mv mdx1] = min(D2);
		%D2 = (right.S - S(idx)).^2;
		%[mv mdx2] = min(D2);
		%W(idx,1) = sqrt( (left.X(mdx1)-right.X(mdx2)).^2 + (left.Y(mdx1)-right.Y(mdx2)).^2 );
	%	W(idx,1) = sqrt( left
	%end
	%obj.width = width;

end % channel_geometry

