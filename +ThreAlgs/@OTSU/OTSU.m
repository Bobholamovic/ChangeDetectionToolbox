classdef OTSU < ThreAlgs.ThreAlg
    properties
        mergeType = 0;   % 0 for average pooling, 1 for Euclidean distance
    end
    methods
        function obj = OTSU(merge_type)
            obj.algName = 'OTSU';
            if exist('merge_type', 'var'), obj.mergeType = merge_type; end
        end
        function CM = segment(obj, DI)
            import Utilities.normMinMax
            % Deals with double type data
            if ndims(DI) == 2
                changeMap2d = im2uint8(normMinMax(DI));
            elseif ndims(DI) == 3
                if obj.mergeType == 0
                    changeMap2d = Utilities.mergeAvg(DI);
                else
                    changeMap2d = Utilities.mergeEucl(DI);
                end
                changeMap2d = im2uint8(normMinMax(changeMap2d));
            else
                error('Handles only 2 or 3 dimensional inputs');
            end
            thre = graythresh(changeMap2d);
            CM = imbinarize(changeMap2d, thre);
        end
    end
end