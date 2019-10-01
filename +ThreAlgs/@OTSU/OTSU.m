classdef OTSU < ThreAlgs.ThreAlg
    methods
        function obj = OTSU()
            obj.algName = 'OTSU';
        end
        function seg_map = segment(obj, change_map)
            % Deals with double type data
            if ndims(change_map) == 2
                changeMap2d = obj.normMinMax(change_map);
            elseif ndims(change_map) == 3
                % Channel-wise mean
                changeMap2d = obj.normMinMax(mean(change_map, 3));
            else
                error('Handles only 2 or 3 dimensional inputs');
            end
            thre = graythresh(changeMap2d);
            seg_map = imbinarize(changeMap2d, thre);
        end
    end
    
    methods(Static)
        function im_normed = normMinMax(change_map)
            % Double in and uint8 out
            maxVal = max(change_map(:));
            minVal = min(change_map(:));
            im_normed = uint8((change_map-minVal)./(maxVal-minVal) * 255);
        end
    end
end