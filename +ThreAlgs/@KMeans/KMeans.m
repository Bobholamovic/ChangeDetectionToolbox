classdef KMeans < ThreAlgs.ThreAlg
    properties (Access=public)
        params cell = {'EmptyAction', 'singleton', 'Maxiter', 1500};
    end
    methods
        function obj = KMeans(varargin)
            obj.algName = 'K-Means';
            if nargin > 0
                obj.params = varargin;
            end
        end
        function seg_map = segment(obj, change_map)
            % Deals with double data
            if (ndims(change_map) ~= 3)
                error('Handles only three-dimensional inputs');
            end
            % Reshape
            [rows, cols] = size(change_map(:, :, 1));
            % Explicitly convert to double type before calling kmeans
            cdMapReshaped = reshape(double(change_map), rows*cols, 3);
            % k is set to 2 with respcet to binary change detection
            % Note that the category with more pixels are deemed unchanged
            seg_map = uint8(reshape(kmeans(cdMapReshaped, 2, obj.params), rows, cols));
            if sum(seg_map(:)==1) > (rows*cols/2)
                seg_map = (seg_map == 2);
            else
                seg_map = (seg_map == 1);
            end
        end
    end
end