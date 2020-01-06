function im_merged = mergeAvg(varargin)
% Average merging on channels
% Support a changing number of inputs
% Merge via Euclidean norm
im_merged = sqrt(sum(cat(3, varargin{:}).^2, 3));
end