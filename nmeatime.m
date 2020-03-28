% 2015-02-01 21:18:48.196523122 +0100
function t = nmeatime(UTC)
	t = cellfun(@first,UTC);
	h = floor(t/10000);
	m = floor((t - h*10000)/100);
	s = t - h*10000 - m*100;
	t = h/24 + m/(1440) + s/(86400);
end
function a = first(a)
	if (isempty(a))
		a = NaN;
	else
		a = str2num(a(1,:));
	end
end

