function im_normed = normMeanStd(im)
% Only for multi-band input
% Channel-wise normalization
meanVal(1,1,:) = mean(mean(im));
stdVal(1,1,:) = std(std(im));
im_normed = (double(im) - meanVal) ./ (stdVal+eps);
end