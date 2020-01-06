function im_clr = pretty(cd_map, seg_map, ref_map, palette)
if ~exist('palette', 'var')
    % Set a default palette
    palette = [255,    0,    0  % TP
        0,  255,  255  % FP
        0,  255,    0  % TN
        255,    0,  255];% FN
end

if size(cd_map, 3) ~= 3
    im_clr = repmat(Utilities.mergeAvg(cd_map), 1, 1, 3);
else
    im_clr = cd_map;
end

im_clr = im2uint8(Utilities.normMinMax(im_clr));

ref_map = Utilities.toLogicalMask(ref_map);
if size(ref_map, 3) > 1
    ref_map = Metrics.CDMetric.combineRefs(ref_map);
end

% TP
[x, y] = find(seg_map == 1 & ref_map == 1);
im_clr = fillColor_(im_clr, x, y, palette(1,:));

% FP
[x, y] = find(seg_map == 1 & ref_map == 0);
im_clr = fillColor_(im_clr, x, y, palette(2,:));

% TN
[x, y] = find(seg_map == 0 & ref_map == 0);
im_clr = fillColor_(im_clr, x, y, palette(3,:));

% FN
[x, y] = find(seg_map == 0 & ref_map == 1);
im_clr = fillColor_(im_clr, x, y, palette(4,:));

end

function im = fillColor_(im, pos_x, pos_y, clr)
for ii = 1:length(pos_x)
    im(pos_x(ii), pos_y(ii), :) = clr;
end
end