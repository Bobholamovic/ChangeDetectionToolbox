classdef ImageRatio < Algorithms.CDAlg
    methods
        function obj = ImageRatio()
            obj@Algorithms.CDAlg('Image Ratioing', '')
        end
        DI = detectChange(obj, ~, ~);
    end
end