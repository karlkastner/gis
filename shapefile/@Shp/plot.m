% 2015-11-01 16:22:12.452279234 +0100
% Karl Kastner, Berlin
function plot(shp,varargin)
	ih = ishold;	
	geometry = [];
	GEOMETRY = 'Line';
	cmap = colormap('lines');
	ncmap = size(cmap,1);
	for idx=1:length(shp)
		if (~isempty(shp(idx).X))
		if (isfield(shp,'Geometry'))
			geometry = shp(idx).Geometry;
		end
		if (isempty(geometry))
			geometry = GEOMETRY;
		else
			GEOMETRY = geometry;
		end
		switch (lower(geometry))
			case {'polygon'}
				if (length(varargin) > 0)
					cmap = varargin{1};
					ncmap = size(cmap,1);
				end
				if (isfield(shp,'ci'))
					%set(gca,'colororderindex',shp(idx).ci);
					ci = shp(idx).ci;
				else
					ci = idx;
				end

%				patch(shp(idx).X,shp(idx).Y,idx);
				[f, v] = poly2fv(shp(idx).X, shp(idx).Y);
				patch('Faces', f, 'Vertices', v, 'FaceColor',  ...
				 cmap(mod(ci,ncmap)+1,:), ... %'r', ...
				 'EdgeColor', 'none');
			otherwise
				%case {'line'}
			if (nargin() < 1)
				if (isfield(shp,'ci'))
					set(gca,'colororderindex',shp(idx).ci);
				end
				plot(shp(idx).X,shp(idx).Y,'.-');
			else
				plot(shp(idx).X,shp(idx).Y,varargin{:});
			end
			% end points
			%hold on
			%set(gca,'ColorOrderIndex',get(gca,'ColorOrderIndex')-1)
			%	plot(shp(idx).X([1 end]),shp(idx).Y([1 end]),'o');
		end
		hold on
		end
	end
	if (~ih)
		hold off
	end
end % plot()

