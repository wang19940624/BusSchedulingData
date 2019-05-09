function res = getTravelSatis(seats,passengers)
    if (0 <= passengers) && (passengers <= seats)
        res = 1;
    elseif (seats < passengers) && (passengers <= 1.2 * seats)
        res = seats * (0.8 * seats + 0.5 * (passengers - seats)) / passengers ^ 2;
    else
        res = 0;
    end
end

% TODO: 座位数40 最大载客量100