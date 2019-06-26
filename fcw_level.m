function warning_level = fcw_level(long_hv,lat_hv,heading_hv,speed_hv,long_rv,lat_rv,heading_rv,speed_rv)
%根据TTC来判断FCW是否触发以及预警等级
%warning_level = 'fcw_info';
ttc_info = 3;%单位:second
ttc_advi = 2.5;
ttc_immi = 2;

%采用二维向量模型进行计算
delta_degree = [long_hv-long_rv,lat_hv-lat_rv];
angle_hv = (450-heading_hv)/180*pi;
e_hv = [cos(angle_hv),sin(angle_hv)];
angle_rv = (450-heading_rv)/180*pi;
e_rv = [cos(angle_rv),sin(angle_rv)];
delta_speed = (speed_hv*e_hv-speed_rv*e_rv)/3.6;%单位:m/s
R = 6371.004;%km
delta_position = delta_degree*pi*R*1000/180;%单位：m
ttc = -1*sum(delta_position.*delta_speed)/norm(delta_speed)/norm(delta_speed);
min_distance = norm(delta_position+ttc*delta_speed);
if min_distance<3 && ttc>0
    if ttc<ttc_immi
        warning_level = 'fcw_immi';
    else if ttc<ttc_advi
            warning_level = 'fcw_advi';
        else if ttc<ttc_info
                warning_level = 'fcw_info';
            else
                warning_level = 0;
            end
        end
    end
else
    warning_level = 0;
end
end

