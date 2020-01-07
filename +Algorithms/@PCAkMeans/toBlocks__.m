function blks = toBlocks__(im, w, mode)
% Crop blocks with no padding
% Set the anchor at the center of each block
hw = floor((w-1)/2);
offsetU = hw; offsetL = hw;
offsetD = w - hw - 1;
offsetR = w - hw - 1;

[rows, cols, chns] = size(im);
if strcmp(mode, 'distinct')
    step = w;
elseif strcmp(mode, 'sliding')
    step = 1;
else
    error('Invalid mode');
end

iiSeries = 1+offsetU:step:rows-offsetD;
jjSeries = 1+offsetL:step:cols-offsetR;
blks = zeros(length(iiSeries) * length(jjSeries), w*w*chns);
cnt = 1;    % Counter
for jj = jjSeries
    for ii = iiSeries
        blks(cnt, :) = reshape(im(ii-offsetU:ii+offsetD, jj-offsetL:jj+offsetR, :), 1, []);
        cnt = cnt + 1;
    end
end
end