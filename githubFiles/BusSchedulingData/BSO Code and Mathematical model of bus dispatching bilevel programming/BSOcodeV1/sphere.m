function z = sphere(x)
% unimodal optimum 0
n = length(x);
z =0;
for idx = 1:n
  z = z + x(idx)^2;
end
