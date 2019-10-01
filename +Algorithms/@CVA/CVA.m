classdef CVA < Algorithms.CDAlg
    methods
        function obj = CVA()
            obj@Algorithms.CDAlg('Change Vector Analysis', '')
        end
        [amp_map, ang_map] = detectChange(obj, ~, ~);
    end
end