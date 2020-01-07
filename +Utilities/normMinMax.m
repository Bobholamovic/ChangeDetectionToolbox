function im_normed = normMinMax(im)
% Double in and uint8 out
maxVal = max(im(:));
minVal = min(im(:));
im_normed = (im-minVal)./(maxVal-minVal);
end