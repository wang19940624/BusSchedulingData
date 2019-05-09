function updateBus( time,type,index )
    global Parameters;
    Parameters.buses(index).start_time = time;
    Parameters.buses(index).details = cell(2,Parameters.stations_num); %发车时间 乘客的ID
    Parameters.buses(index).details{1,1} = time;
    Parameters.buses(index).type = type;
    for i=1:Parameters.stations_num-1
        T = min(floor(time/3600) + 1,16);
        speed = Parameters.speed(type,T);
        if type == 1
            time = time + getTime(Parameters.stations(i),speed) + Parameters.updown_time;
        else
            time = time + getTime(Parameters.stations(Parameters.stations_num-i),speed) + Parameters.updown_time;
        end        
        Parameters.buses(index).details{1,i+1} = time;
    end
end

