function [DI, k] = detectChange(obj, t1, t2)
delta = abs(double(t1) - double(t2));
if size(t1, 3) == 1
    k = 1;
    DI = delta;
    return;
end
[DI, ~, ~] = Utilities.PCA(delta, obj.nPCUsed);
DI = abs(DI);   % IMPORTANT, take the absolute value
k = size(DI, 3);
end