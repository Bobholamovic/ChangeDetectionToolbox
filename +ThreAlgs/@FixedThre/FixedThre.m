classdef FixedThre < ThreAlgs.ThreAlg
    properties
        thre;
    end
    methods
        function obj = FixedThre(thre)
            obj.algName = 'Segmentation using a fixed threshold';
            obj.thre = thre;
        end
        function CM = segment(obj, DI)
            if size(DI, 3) > 1
                cdMap2d = Utilities.mergeAvg(DI);
            end
            CM = (cdMap2d > obj.thre);
        end
    end
end