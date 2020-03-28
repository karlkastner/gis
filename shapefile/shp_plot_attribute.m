function shp_plot_attribute(shp)
	state = ishold();
	for idx=1:length(shp);
	c='k';
	switch(shp(idx).side);
		case {'south'};
			c='r';
		case{'east'};
			c='g';
		case{'north'};
			c='b';
		case{'west'};
			c='yellow';
		end;
		plot(shp.shp(idx).X,shp.shp(idx).Y,c);
		hold on;
	end
	if (~state)
		hold off;
	end
end

