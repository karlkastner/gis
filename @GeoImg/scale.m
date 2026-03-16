function obj2 = scale(obj,s)
	obj2 = GeoImg();
	obj2.pgw = obj.pgw;
s
	obj2.img = imresize(obj.img,s,'Method','bilinear');
	s_ = size(obj2.img)./size(obj.img)
	obj2.pgw(1) = 1/s_(1)*obj2.pgw(1);
	obj2.pgw(2) = 1/s_(2)*obj2.pgw(2);
	obj2.pgw(3) = 1/s_(1)*obj2.pgw(3);
	obj2.pgw(4) = 1/s_(2)*obj2.pgw(4);
end

