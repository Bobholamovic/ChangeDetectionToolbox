function [DI, coeffs] = detectChange(obj, t1, t2)
ord = 1;
[nRows, nCols, nChns] = size(t1);
coeffs = zeros(nChns, ord+1);
DI = zeros(size(t1));
for c = 1:nChns
    xc = double(t1(:,:,c));
    yc = double(t2(:,:,c));
    coeffs(c,:) = polyfit(xc(:), yc(:), ord);
    pred = polyval(coeffs(c,:), xc(:));
    DI(:,:,c) = abs(reshape(pred, nRows, nCols) - double(t2(:,:,c)));
end
end
