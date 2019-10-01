classdef FMeasure < Metrics.Recall & Metrics.OA  
    properties (Access=public)
        alpha = 1;
    end
    methods
        function obj = FMeasure(varargin)
            if nargin > 1
                error('Too many input arguments');
            end
            if nargin == 1
                % No type-checking here
                object.alpha = varargin{1};
            end
            obj@Metrics.Recall();
            obj@Metrics.OA();
        end
    end
    
    methods (Access=public)
        function score = gauge(obj, pred, gnd, ~)
            recall = gauge@Metrics.Recall(obj, pred, gnd);
            oa = gauge@Metrics.OA(obj, pred, gnd);
            alpha2 = obj.alpha.^2;
            score = ((alpha2+1) .* oa .* recall) ./ (alpha2 .* (oa+recall));
        end
    end
end