function z = rastrigin(x)
% Multimodal optimum 0
n = length(x);
z = 0;
for idx = 1:n
    z = z + x(idx)^2 + 10 - 10 * cos(2*pi*x(idx));
end
