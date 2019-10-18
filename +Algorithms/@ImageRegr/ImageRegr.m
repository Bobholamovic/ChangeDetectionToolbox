classdef ImageRegr < Algorithms.CDAlg
    methods
        function obj = ImageRegr()
            obj@Algorithms.CDAlg('Image Regression', '')
        end
        [DI, coeffs] = detectChange(obj, ~, ~);
    end
end