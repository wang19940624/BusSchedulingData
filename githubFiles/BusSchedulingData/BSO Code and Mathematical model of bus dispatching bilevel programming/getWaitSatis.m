function res = getWaitSatis(T,time,high)    
    if find(high == T)
        if (0 <= time) && (time <= 120)            
            res = 1;
        elseif (120 < time) && (time <= 300) 
            res = 5/3 - time/3;
%         elseif time > 300
        else
            res = 0;
        end
    else
        if (0 <= time) && (time <= 300)            
            res = 1;
        elseif (300 < time) && (time <= 600) 
            res = 2 - time/5;
%         elseif time > 600
        else
            res = 0;
        end
    end
end

