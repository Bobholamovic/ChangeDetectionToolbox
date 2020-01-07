function mask = toLogicalMask(im)
mask = (im > min(im(:)));
end