function res = getBusSatis(seats,passengers)
    if (seats <= passengers) && (passengers <= 1.2 * seats)
        res = 1;
    elseif (0 <= passengers) && (passengers < seats)
        res = passengers / seats;
    elseif passengers > 1.2 * seats
        res = 0;
    end
end

% TODO: 座位数40 最大载客量100