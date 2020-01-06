function im_merged = mergeAvg(varargin)
% Average merging on channels
% Support a changing number of inputs
% Merge via channel-wise max
im_merged = max(cat(3, varargin{:}), [], 3);
end