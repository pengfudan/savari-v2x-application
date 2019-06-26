%Savari V2X Application
close all;
%% 仿真
table_all = interop20190501065748(16693:27388,:);
TimeStamp_ms = table2array(table_all(:,2));
LogRecType = table2array(table_all(:,3));
lat = table2array(table_all(:,21));
long = table2array(table_all(:,22));
elev = table2array(table_all(:,23));
speed = table2array(table_all(:,28));
heading = table2array(table_all(:,29));

VehicleWidth = 2;
VehicleLength = 5;

TimeStamp_ms_hv = TimeStamp_ms(LogRecType=='TX');
lat_hv = lat(LogRecType=='TX');
long_hv = long(LogRecType=='TX');
elev_hv = elev(LogRecType=='TX');
speed_hv = speed(LogRecType=='TX');
heading_hv = heading(LogRecType=='TX');

TimeStamp_ms_rv = TimeStamp_ms(LogRecType=='RX');
lat_rv = lat(LogRecType=='RX');
long_rv = long(LogRecType=='RX');
elev_rv = elev(LogRecType=='RX');
speed_rv = speed(LogRecType=='RX');
heading_rv = heading(LogRecType=='RX');



lat_late_hv = lat_hv(2:length(lat_hv));
lat_early_hv = lat_hv(1:length(lat_hv)-1);
long_late_hv = long_hv(2:length(long_hv));
long_early_hv = long_hv(1:length(long_hv)-1);
delta_dis = lonlat2dis(long_late_hv,lat_late_hv,long_early_hv,lat_early_hv);
delta_time = TimeStamp_ms_hv(2:length(TimeStamp_ms_hv))-TimeStamp_ms_hv(1:length(TimeStamp_ms_hv)-1);
delta_time = delta_time/1000/60/60;
vel_cal = delta_dis./delta_time;

%plot(long_hv,lat_hv);
figure;
% plot(long_hv(1),lat_hv(1),'*');
% axis([121.622,121.628,31.2332,31.2339]);
for i = 1:(length(lat_hv)-1)
    plot(long_hv(i),lat_hv(i),'--gs','LineWidth',1.5,'MarkerSize',6,'MarkerEdgeColor','r','MarkerFaceColor',[0.5,0.5,0.5]);
    axis([121.621,121.628,31.2331,31.2339]);
    %txt = ['hv:',num2str(heading_hv(i))];
    %text(long_hv(i),lat_hv(i),txt);
    hold on;
    plot(long_rv(i),lat_rv(i),'--gs','LineWidth',1.5,'MarkerSize',6,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5]);
    axis([121.621,121.628,31.2331,31.2339]);
    %txt = ['rv:',num2str(heading_rv(i))];
    %text(long_rv(i),lat_rv(i),txt);
    
    if lonlat2dis(long_hv(i),lat_hv(i),long_rv(i),lat_rv(i))<0.5%500米以外不被考虑在内
        if isFront(long_hv(i),lat_hv(i),heading_hv(i),long_rv(i),lat_rv(i))%在正前方才有可能触发FCW
            warning_level = fcw_level(long_hv(i),lat_hv(i),heading_hv(i),speed_hv(i),long_rv(i),lat_rv(i),heading_rv(i),speed_rv(i));
            if warning_level~=0
                text(long_hv(i),lat_hv(i),warning_level);
            end
        end
        if isLRrear(long_hv(i),lat_hv(i),heading_hv(i),long_rv(i),lat_rv(i))%在左右后方才有可能触发BSW/LCW
            %warning_level = fcw_level(long_hv(i),lat_hv(i),heading_hv(i),speed_hv(i),long_rv(i),lat_rv(i),heading_rv(i),speed_rv(i));
            text(long_hv(i),lat_hv(i),'bsw');
        end
    end
    
    hold off;
    pause(delta_time(i))
end

figure;
plot(vel_cal);hold on;
plot(speed_hv,'r');
