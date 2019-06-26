function distance = lonlat2dis(long1,lat1,long2,lat2)
%lonlat2dis
R = 6371.004;%km
distance = pi*R*acos(sin(lat1).*sin(lat2)+cos(lat1).*cos(lat2).*cos(long2-long1))/180;
end

