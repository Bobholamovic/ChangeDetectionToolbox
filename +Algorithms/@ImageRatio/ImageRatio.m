classdef ImageRatio < Algorithms.CDAlg
    methods
        function obj = ImageRatio() 
            obj@Algorithms.CDAlg('Image Ratioing', '')
        end
        change_map = detectChange(obj, ~, ~);
    end
end