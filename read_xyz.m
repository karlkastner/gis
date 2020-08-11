% Fri 13 Jan 20:52:46 CET 2017
function [x y z] = read_xyz(name)
	[x y z]=textread(name,'%f%f%f');
end

