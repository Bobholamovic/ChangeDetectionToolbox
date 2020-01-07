function [DI, k] = detectChange(obj, t1, t2)
k = min(size(t1, 3), size(t2, 3));
k = min(obj.nPCUsed, k);

if k == 1
    DI = abs(double(t1) - double(t2));
    return;
end

[rows, cols, chns] = size(t1);
[pcs1, ~, ~] = Utilities.PCA(reshape(t1, rows*cols, chns), k);
[pcs2, ~, ~] = Utilities.PCA(reshape(t2, rows*cols, chns), k);

% Assure that the PCs of the two images are positively correlated
pcs2 = pcs2 .* sign(sum((pcs1-mean(pcs1)).*(pcs2-mean(pcs2))));
DI = reshape(abs(pcs1 - pcs2), rows, cols, k);
end