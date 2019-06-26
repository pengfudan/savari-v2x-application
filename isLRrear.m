function islrrear = isLRrear(long_hv,lat_hv,heading_hv,long_rv,lat_rv)
%返回1表示在左右后方，返回0表示不在左右后方
angle = (450-heading_hv)/180*pi;
e = [cos(angle),sin(angle)];
delta_long = long_rv - long_hv;
delta_lat = lat_rv - lat_hv;
delta_dir = [delta_long,delta_lat];
%水平坐标分量
para = sum(e.*delta_dir);
%正交经纬度差
orth_delta = delta_dir-para*e;
orth_dis = 1000*lonlat2dis(long_hv,lat_hv,long_hv+orth_delta(1),lat_hv+orth_delta(2));%单位:m
if para<0&&orth_dis>4.5%depends on vehicle size
    islrrear = 1;
else
    islrrear = 0;
end
end

