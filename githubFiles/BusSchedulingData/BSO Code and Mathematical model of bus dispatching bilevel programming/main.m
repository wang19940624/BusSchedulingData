% 公交发车表 包括发车时段T 发车间隔interval 各时段行驶速度v  6点到22点
% 公交线路表 包括特定线路的所有车站名称与距离(km)
% 乘客信息表 包括乘客ID 到达出发车站的时间t 出发站与目的站 以及最终的等待时间
% 车辆信息表 包括车辆ID 发车时刻 每站点到站时刻 乘客ID 乘车舒适度 载客满意度
% 通过对发车间隔与车辆行驶速度的控制，保证车辆实际使用数、车辆运行率（车辆始终运转 不因发车间隔而停转）、 乘车舒适度和载客满意度之间的平衡
% 忽略上下行路线之间的细微差异 将之对齐
clear;clc;
%% init_parameters
global Parameters;
Parameters = struct(); % Parameters 是包括了所有超参数的结构体
Parameters.stations_num = 40;
Parameters.passenger_up = 20000;
Parameters.passenger_down = 20000;
Parameters.passenger_sum = Parameters.passenger_up + Parameters.passenger_down;
Parameters.seats = 40;
Parameters.passengers_max = 100;
Parameters.updown_time = 10; % 单位 秒
Parameters.speed_max = 40; % 单位 km/h
Parameters.intervals = zeros(2,16); % 单位 分钟
Parameters.intervals(:) = 10;
Parameters.speed = zeros(2,16); % 单位 km/h
Parameters.speed(:) = 30;
Parameters.stations = randi([500,1000],1,Parameters.stations_num-1); % Stations(i) 表示i站点与i+1站点之间的距离 单位为米
Parameters.buses = struct(); % Buses 是包括了所有车辆的结构体
Parameters.passengers_up = zeros(Parameters.passenger_up,4); % Passengers 是包括了所有乘客的结构体
Parameters.passengers_down = zeros(Parameters.passenger_down,4);
rand_time_up = sort(randi(3600*16 - 1,1,Parameters.passenger_up));
rand_time_down = sort(randi(3600*16 - 1,1,Parameters.passenger_down));
for i=1:Parameters.passenger_up
    Parameters.passengers_up(i,1) = rand_time_up(i);
    Parameters.passengers_up(i,2) = randi(Parameters.stations_num-1);
    Parameters.passengers_up(i,3) = randi([Parameters.passengers_up(i,2)+1,Parameters.stations_num]);
    Parameters.passengers_up(i,4) = -1;
end
for i=1:Parameters.passenger_down
    Parameters.passengers_down(i,1) = rand_time_down(i);
    Parameters.passengers_down(i,2) = randi(Parameters.stations_num-1);
    Parameters.passengers_down(i,3) = randi([Parameters.passengers_down(i,2)+1,Parameters.stations_num]);
    Parameters.passengers_down(i,4) = -1;
end
%% loop the simulation
% 计算车辆的情况
% 初始化车辆信息表 包括车辆ID 发车时刻 每站点到站时刻 乘客ID 乘车舒适度 载客满意度
cur_index_up = [];
cur_index_down = [];
cur_free_bus = [0,0]; % 停转车辆数目
total_bus = 0; % 实际投入运行车辆总数
next_index = 1;
time_up = [];
time_down = [];
for i=1:16
    time_up = [time_up (1+(i-1)*3600):Parameters.intervals(1,i)*60:i*3600];
    time_down = [time_down (1+(i-1)*3600):Parameters.intervals(2,i)*60:i*3600];
end
time_total = [time_up time_down];
time_total = unique(sort(time_total));
for i=1:length(time_total)
    % 更新新增车辆的信息
    % 上行
    if find(time_up == time_total(i))
        if cur_free_bus(1) > 0
            cur_free_bus(1) = cur_free_bus(1) - 1;
            total_bus = total_bus - 1;
        end
        updateBus(time_total(i),1,next_index)
        cur_index_up = [cur_index_up next_index];
        next_index = next_index + 1;
        total_bus = total_bus + 1;
    end
    % 下行
    if find(time_down == time_total(i))
        if cur_free_bus(2) > 0
            cur_free_bus(2) = cur_free_bus(2) - 1;
            total_bus = total_bus - 1;
        end
        updateBus(time_total(i),2,next_index)
        cur_index_down = [cur_index_down next_index];
        next_index = next_index + 1;
        total_bus = total_bus + 1;
    end
    
    % 更新运行的车辆ID以及闲置的车辆数 假定先发的车永远在后发的车前面 不会被超过，
    % 所以只需要在每次发车时刻更新上/下行的首辆车即可
    if Parameters.buses(cur_index_up(1)).details{1,Parameters.stations_num} <= time_total(i)
        cur_free_bus(2) = cur_free_bus(2) + 1;
        cur_index_up(1) = [];
    end
    if Parameters.buses(cur_index_down(1)).details{1,Parameters.stations_num} <= time_total(i)
        cur_free_bus(1) = cur_free_bus(1) + 1;
        cur_index_down(1) = [];
    end
end
% 计算乘客的等待时间以及所属车辆
for i=1:next_index-1
    type = Parameters.buses(i).type;
    if type == 1 % 上行
        for j=1:Parameters.stations_num-1
            time = Parameters.buses(i).details{1,j};
            % 下车
            if ~isempty(Parameters.buses(i).details{2,j})
                index_down = find(Parameters.passengers_up(Parameters.buses(i).details{2,j},3) == j);
                Parameters.buses(i).details{2,j}(index_down) = [];
            end
            % 上车
            index = find(Parameters.passengers_up(:,2) == j & Parameters.passengers_up(:,1) <= time & Parameters.passengers_up(:,4) == -1);
            if length(index) > Parameters.passengers_max
                index = index(1:Parameters.passengers_max);
            end
            Parameters.buses(i).details{2,j} = index;
            for k=1:length(index)
                Parameters.passengers_up(index(k),4) = time - Parameters.passengers_up(index(k),1);
            end
        end
    else % 下行
        for j=1:Parameters.stations_num-1
            time = Parameters.buses(i).details{1,j};
            % 下车
            if ~isempty(Parameters.buses(i).details{2,j})
                index_down = find(Parameters.passengers_down(Parameters.buses(i).details{2,j},3) == j);
                Parameters.buses(i).details{2,j}(index_down) = [];
            end
            % 上车
            index = find(Parameters.passengers_down(:,2) == j & Parameters.passengers_down(:,1) <= time & Parameters.passengers_down(:,4) == -1);
            if length(index) > Parameters.passengers_max
                index = index(1:Parameters.passengers_max);
            end
            Parameters.buses(i).details{2,j} = index;
            for k=1:length(index)
                Parameters.passengers_down(index(k),4) = time - Parameters.passengers_down(index(k),1);
            end
        end
    end
end
% 计算乘客等待时间满意度
high = [2,3,12,13];
pass_up = Parameters.passengers_up(:,[1,4]);
pass_up(:,1) = floor(pass_up(:,1)/3600) + 1;
pass_down = Parameters.passengers_down(:,[1,4]);
pass_down(:,1) = floor(pass_down(:,1)/3600) + 1;
W = 0;
for i=1:Parameters.passenger_up
    res = getWaitSatis(pass_up(i,1),pass_up(i,2),high);
    W = W + res;
end
for i=1:Parameters.passenger_down
    res = getWaitSatis(pass_down(i,1),pass_down(i,2),high);
    W = W + res;
end
W = W / Parameters.passenger_sum;
% 计算乘客乘车舒适度
S = 0;
for i=1:next_index - 1
    for j=1:Parameters.stations_num
        res = getTravelSatis(Parameters.seats,length(Parameters.buses(i).details{2,j}));
        S = S + res;
    end    
end
satis_passenger = (0.7 * W + 0.3 * S) / 2;
% 公交公司载客满意度
satis_bus = 0;
for i=1:next_index - 1
    for j=1:Parameters.stations_num-1
        res = getTravelSatis(Parameters.seats,length(Parameters.buses(i).details{2,j}));
        satis_bus = satis_bus + res;
    end    
end
satis_bus = satis_bus / (Parameters.stations_num-1) / (next_index-1);
cost = 100;
cost_bus = total_bus * cost;