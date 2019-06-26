function isfront = isFront(long_hv,lat_hv,heading_hv,long_rv,lat_rv)
%����1��ʾ����ǰ��������0��ʾ������ǰ��
angle = (450-heading_hv)/180*pi;
e = [cos(angle),sin(angle)];
delta_long = long_rv - long_hv;
delta_lat = lat_rv - lat_hv;
delta_dir = [delta_long,delta_lat];
%ˮƽ�������
para = sum(e.*delta_dir);
%������γ�Ȳ�
orth_delta = delta_dir-para*e;
orth_dis = 1000*lonlat2dis(long_hv,lat_hv,long_hv+orth_delta(1),lat_hv+orth_delta(2));%��λ:m
if para>0&&orth_dis<4.5%orth_dis<4.5 depends on vehicle size
    isfront = 1;
else
    isfront = 0;
end
end

