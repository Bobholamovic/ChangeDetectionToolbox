function im_normed = normMeanShift(im)
% Only for multi-band input
% Channel-wise mean shift
meanVal(1,1,:) = mean(mean(im));
im_normed = double(im) - meanVal;
end