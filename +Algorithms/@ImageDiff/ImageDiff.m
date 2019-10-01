classdef ImageDiff < Algorithms.CDAlg
    methods
        function obj = ImageDiff()
            obj@Algorithms.CDAlg('Image Differencing', '')
        end
        change_map = detectChange(obj, ~, ~);
    end
end