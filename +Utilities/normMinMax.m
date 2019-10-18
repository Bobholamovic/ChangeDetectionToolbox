function im_normed = normMinMax(im)
    % Double in and uint8 out
    maxVal = max(im(:));
    minVal = min(im(:));
    im_normed = uint8((im-minVal)./(maxVal-minVal) * 255);
end