classdef IRMAD < Algorithms.CDAlg
    properties (Access=public)
        nMADUsed = uint8(255);
        % The default values are set according to 
        % http://people.compute.dtu.dk/alan/software.html
        nIters = 30;
        epsilon = 1e-2;
        lambda = 1; % A penalty term, reserved
    end
    methods
        function obj = IRMAD(k, max_iter, epsilon, lambda)
            obj@Algorithms.CDAlg('Iterative Reweighted MAD', ...
            	['A. A. Nielsen, ',...
                '¡°The Regularized Iteratively Reweighted MAD Method ',...
                'for Change Detection in Multi- and Hyperspectral Data,¡±',...
                'IEEE Trans. on Image Process., vol. 16, no. 2, pp. 463¨C478, 2007.'] ...
                );
            if exist('max_iter', 'var')
                obj.nIters = max_iter;
            end
            if exist('epsilon', 'var')
                obj.epsilon = epsilon;
            end
            if exist('lambda', 'var')
                obj.lambda = lambda;
            end
            if exist('k', 'var')
                obj.nMADUsed=uint8(k);
            end
        end
        [DI, k, mad, w, chi2] = detectChange(obj, t1, t2);
        [c, xc] = covW(obj, x, w);
    end
end