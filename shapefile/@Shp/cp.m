% 2016-09-28 14:22:24.556355509 +0200
%
%% copy a shapefile on disk
%
function cp(iname,oname)
	extension = {'shp','shx','dbf'};
	for idx=1:length(extension)
		iname_ = [iname(1:end-3),'.',extension{idx}];
		oname_ = [oname(1:end-3),'.',extension{idx}];
		if (exist(iname_,'file'))
			copyfile(iname_,oname_);
		end
	end
end
