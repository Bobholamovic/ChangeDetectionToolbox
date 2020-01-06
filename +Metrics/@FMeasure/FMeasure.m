classdef FMeasure < Metrics.Recall & Metrics.UA
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
            obj@Metrics.UA();
        end
    end
    
    methods (Access=public)
        function score = gauge(obj, pred, gnd, ~)
            pa = gauge@Metrics.Recall(obj, pred, gnd);
            ua = gauge@Metrics.UA(obj, pred, gnd);
            alpha2 = obj.alpha.^2;
            score = ((alpha2+1) .* ua .* pa) ./ (alpha2 .* (ua+pa)+eps);
        end
    end
end