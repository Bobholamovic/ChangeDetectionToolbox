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
        function CM = segment(obj, DI)
            % Reshape
            [rows, cols, chns] = size(DI);
            % Explicitly convert to double type before calling kmeans
            cdMapReshaped = reshape(double(DI), rows*cols, chns);
            % k is set to 2 with respcet to binary change detection
            % Note that the category with more pixels are deemed unchanged
            CM = uint8(reshape(kmeans(cdMapReshaped, 2, obj.params{:}), rows, cols));
            
            % Determine the foreground and background pixels according to
            % class average value
            meanCDMap = Utilities.mergeAvg(DI);
            if mean(meanCDMap(CM==1)) > mean(meanCDMap(CM==2))
                % 1 for change and 0 for unchange
                CM = (CM==1);
            else
                CM = (CM==2);
            end
        end
    end
end