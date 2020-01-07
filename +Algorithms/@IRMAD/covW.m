function [c, xc] = covW(obj, x, w)
sw = sum(w);
mx = (w' * x) ./ sw;

xc = x-mx;

N = size(x, 1);
% Direct method uses way too much memory
tmp = sqrt(w) .* xc;
c = (tmp' * tmp) ./ ((N-1) * sw / N);
end