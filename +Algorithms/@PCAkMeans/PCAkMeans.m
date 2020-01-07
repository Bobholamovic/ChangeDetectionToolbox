classdef PCAkMeans < Algorithms.CDAlg
    properties (Constant, Access=private)
        kmeans__ = ThreAlgs.KMeans();
    end
    properties
        blockSize = 3;
        dimFeats = 3;
    end
    methods
        function obj = PCAkMeans(bs, df)
            obj@Algorithms.CDAlg('Change Detection PCA k-Means', ...
                ['T. Celik, "Unsupervised Change Detection in Satellite ',...
                'Images Using Principal Component Analysis ',...
                'and $k$-Means Clustering," ',...
                'in IEEE Geoscience and Remote Sensing Letters, ',...
                'vol. 6, no. 4, pp. 772-776, Oct. 2009.']...
                );
            if exist('bs', 'var'), obj.blockSize = bs; end
            if exist('df', 'var'), obj.dimFeats = df; end
            
            % The original work contains this
            if obj.blockSize < 5
                obj.dimFeats = obj.blockSize .^ 2;
                % Disp a warning
                warning(['PCAkMeans will use dimFeats=',num2str(obj.dimFeats)]);
            end
        end
        change_map = detectChange(obj, t1, t2);
    end
    
    methods (Static, Access=private)
        blks = toBlocks__(im, w, mode)
    end
end