function time = getTime(distance,speed)
%GETTIME 此处显示有关此函数的摘要
%   此处显示详细说明
    a1 = 8;
    a2 = 2;
    t1 = speed / a1;
    t2 = speed / a2;
    t3 = (distance - 0.5*a1*t1^2 - 0.5*a2*t2^2) / speed;
    time = t1 + t2 + t3;
end

