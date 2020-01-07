classdef UA < Metrics.CDMetric
    methods
        function obj = UA()
            % User's accuracy
            obj@Metrics.CDMetric();
        end
    end
    
    methods (Access=public)
        function precision = gauge(obj, pred, gnd, ~)
            TP = Metrics.CDMetric.getTP(pred, gnd);
            FP = Metrics.CDMetric.getFP(pred, gnd);
            precision = TP ./ (TP + FP);
        end
    end
end