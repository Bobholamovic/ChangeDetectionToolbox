classdef ImageDiff < Algorithms.CDAlg
    methods
        function obj = ImageDiff()
            obj@Algorithms.CDAlg('Image Differencing', '')
        end
        DI = detectChange(obj, ~, ~);
    end
end