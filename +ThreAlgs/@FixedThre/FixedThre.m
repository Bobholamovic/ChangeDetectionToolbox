classdef FixedThre < ThreAlgs.ThreAlg
    properties
        thre;
    end
    methods
        function obj = FixedThre(thre)
            obj.algName = 'Segmentation using a fixed threshold';
            obj.thre = thre;
        end
        function seg_map = segment(obj, change_map)
            if size(change_map, 3) > 1
                cdMap2d = mean(change_map, 3);
            end
            seg_map = (cdMap2d > obj.thre);
        end
    end
end