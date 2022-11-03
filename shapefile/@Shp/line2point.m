% Wed 17 Jul 17:46:50 CEST 2019
%
%% convert lines to points
%
function shp_ = line2point(shp)
%	X = shp.X;
	shp_ = struct();
%	[shp_.X] = deal(shp.X);
	shp_= struct('X',num2cell(shp.X),'Y',num2cell(shp.Y));
	f_C = fieldnames(shp);
	for f=rvec(f_C)
		switch(f{1})
		case {'X','Y'}
			% nothing to do
		otherwise
			val = shp.(f{1});
			if (length(val) == length(shp_))
				C = num2cell(val);
				[shp_.(f{1})] = C{:};
			else
				[shp_.(f{1})] = deal(val);
			end
		end
	end
	for idx=1:length(shp_)
		shp_(idx).Geometry = 'Point';
	end
end
