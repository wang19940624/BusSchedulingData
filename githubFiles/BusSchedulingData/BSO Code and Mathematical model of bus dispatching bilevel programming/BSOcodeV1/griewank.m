%Griewank
function z = griewank(x)
% unimodal optimum 0
[m,n]=size(x);
for j=1:m
    for e=1:n
        f1(e)=x(j,e)^2;
        f2(e)=cos(x(j,e)/sqrt(e));
    end
        z(j)=(sum(f1))/4000-(prod(f2))+1;
end