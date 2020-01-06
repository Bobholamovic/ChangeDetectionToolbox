function im_merged = mergeAvg(varargin)
% Average merging on channels
% Support a changing number of inputs
% Merge via channel-wise averaging
im_merged = mean(cat(3, varargin{:}), 3);
end