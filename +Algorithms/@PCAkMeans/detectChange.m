function CM = detectChange(obj, t1, t2)
% Since the paper did not discuss the case of multiple bands, I simply
% concatenate the features of all bands along the column dimension.
%
% Note that the output of this method, namely CM, is already a binary one
%
% Referred to the original implementation from the author
% and https://github.com/rulixiang/ChangeDetectionPCAKmeans
%
bs = obj.blockSize;
df = obj.dimFeats;

% Calculate size and pre-allocate memory
[rows, cols, chns] = size(t1);
eles = bs*bs;
feats = zeros(rows*cols, df*chns);

for c = 1:chns
    % Calculate difference
    delta = abs(double(t1(:,:,c)) - double(t2(:,:,c)));
    % Extract NON-OVERLAPPING blocks
    % With no padding as this can be seen as kinda selecting samples
    patterns = obj.toBlocks__(delta, bs, 'distinct');
    
    % Calculate eigenvectors
    [~, evs, ~] = Utilities.PCA(patterns, df);
    
    % Traverse again to extract OVERLAPPING blocks
    % Perform "SAME" padding on all four borders
    hw = floor((bs-1)/2);
    padU = hw; padL = hw;
    padD = bs - hw - 1;
    padR = bs - hw - 1;
    % Pad it
    deltaPadded = [repmat(delta(1,:,:), padU, 1); delta; repmat(delta(end,:,:), padD, 1)];
    deltaPadded = [repmat(deltaPadded(:,1,:), 1, padL), deltaPadded, repmat(deltaPadded(:,end,:), 1, padR)];
    % Extract blocks
    patterns = obj.toBlocks__(deltaPadded, bs, 'sliding');
    
    % Subtract mean and perform PCA
    feats(:,(c-1)*df + [1:df]) = (patterns - repmat(mean(patterns, 2), 1, eles)) * evs(:, 1:df);
end
% K-Means segmentation using all df*chns feature vectors
CM = obj.kmeans__.segment(reshape(abs(feats), rows, cols, df*chns));
end
