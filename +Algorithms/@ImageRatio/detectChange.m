function DI = detectChange(obj, t1, t2)
% Use logarithm for ease of the following thresholding
DI = abs(log(double(t1)+eps) - log((double(t2) + eps)));
end

