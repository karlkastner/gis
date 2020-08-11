% Di 16. Feb 14:07:00 CET 2016
function write_xyz(name,x,y,z)
	fid = fopen(name,'w');
	if (fid <= 0)
		error(['Unable to open file ',name,' for writing.\n']);
	end
	fprintf(fid,'%15.3f %15.3f %15.3f\n',[double(rvec(x)); double(rvec(y)); double(rvec(z))]);
	fclose(fid);	
end
