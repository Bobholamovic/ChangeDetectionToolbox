classdef PCDA < Algorithms.CDAlg
    properties
        nPCUsed = uint8(255);
    end
    methods
        function obj = PCDA(k)
            obj@Algorithms.CDAlg('Principal Component Differential Analysis', '');
            if exist('k', 'var'), obj.nPCUsed=uint8(k); end
        end
        [DI, k] = detectChange(obj, t1, t2);
    end
end