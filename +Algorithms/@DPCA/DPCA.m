classdef DPCA < Algorithms.CDAlg
    properties
        nPCUsed = uint8(255);
    end
    methods
        function obj = DPCA(k)
            obj@Algorithms.CDAlg('Differential Principal Component Analysis', '');
            if exist('k', 'var'), obj.nPCUsed=uint8(k); end
        end
        [DI, k] = detectChange(obj, t1, t2);
    end
end