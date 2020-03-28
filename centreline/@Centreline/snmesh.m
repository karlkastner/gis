% Mo 25. Jan 15:04:59 CET 2016
% Karl Kastner, Berlin

function [X Y S N sdx pdx obj] = snmesh(obj,x0,y0,ds,k)
	seg_id_ = obj.segment.seg_id_;
	X1 = obj.X(seg_id_(:,1));
	XE = obj.X(seg_id_(:,2));
	Y1 = obj.Y(seg_id_(:,1));
	YE = obj.Y(seg_id_(:,2));
	if (~isempty(x0))
		% global coordinates
		d1 = obj.distance(X1,Y1,x0,y0);
		de = obj.distance(XE,YE,x0,y0);
	else
		% local coordinates
		d1 = zeros(size(X1));
		de = zeros(size(X1));
	end

	S_=[];
	X_  = [];
	Y_  = [];
	Pl_ = [];
	Pr_ = [];
	sdx = [];
	pdx = [];

	% for each segment
	for idx=1:obj.segment.n
		Sc = obj.segment.Sc(idx);
		S  = obj.segment.S(idx);
		X  = cvec(obj.segment.X(idx));
		Y  = cvec(obj.segment.Y(idx));
		id = obj.segment.id{idx};

		if (d1(idx) <= de(idx))
			S    = S  + d1(idx);
			Sc   = Sc + d1(idx);
			flag = false;
		else
			Sc   = de(idx) - Sc + S(end);
			S    = de(idx) - flipud(S) + S(end); % not + Sc
			X    = flipud(X);
			Y    = flipud(Y);
			flag = true;
			% TODO, do not reintegrate
			%S = de(idx)+[0;cumsum(hypot(diff(X),diff(Y)))];
			%[S S__]
			%pause
		end
	
		if (ds > 0)
			Si = cvec(ceil(S(1)/ds)*ds:ds:floor(S(end)/ds)*ds);
			sdx = [sdx; idx*ones(size(Si))];
			%Si = (S(1)/ds)*ds:ds:(S(end)/ds)*ds;
			if (1 == k)
				% obj coordinate only
				Xi = interp1(S,X,Si);
				Yi = interp1(S,Y,Si);
			else
				% left and right coordinate
				Pl = obj.segment.Pl(idx);
				Pr = obj.segment.Pr(idx);
				if (flag)
					Pl = flipud(Pl);
					Pr = flipud(Pr);
				end
				Pli  = interp1(Sc,Pl,Si);
				Pri  = interp1(Sc,Pr,Si);
				pdxi = interp1( S,id,Si,'nearest');
			end
		else
			Si = [S(1); S(end)];
			Xi = [X(2); X(end-1)];
			Yi = [Y(2); Y(end-1)];
		end
		% concatenate
		S_  = [S_; Si];
		pdx = [pdx; pdxi];
		if (1 == k)
			X_ = [X_;Xi];
			Y_ = [Y_;Yi];
		else
			Pl_ = [Pl_; Pli];
			Pr_ = [Pr_; Pri];
		end
	end % for idx
	S   = S_;
	if (1 == k)
		X = X_;
		Y = Y_;
	else
		Pl = Pl_;
		Pr = Pr_;

		% inner points
		nrel = (1:k)/(k+1);
		one = ones(1,k);

		w = sqrt((Pr(:,1)-Pl(:,1)).^2 + (Pr(:,2)-Pl(:,2)).^2);
		% mesh
		X = Pl(:,1)*one + (Pr(:,1)-Pl(:,1))*nrel;
		Y = Pl(:,2)*one + (Pr(:,2)-Pl(:,2))*nrel;
		S = S*one;
		sdx = sdx*one;
		pdx = pdx*one;
		%N = w*ones(size(pdx,1),1)*(nrel-0.5);
		N = w*(nrel-0.5);
	end
end % snmesh

