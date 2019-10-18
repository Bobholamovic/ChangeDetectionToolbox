classdef Recall < Metrics.CDMetric
    methods
        function obj = Recall()
            % Producer's accuracy
            obj@Metrics.CDMetric();
        end
    end
    
    methods (Access=public)
        function recall = gauge(obj, pred, gnd, ~)
            TP = Metrics.CDMetric.getTP(pred, gnd);
            FN = Metrics.CDMetric.getFN(pred, gnd);
            recall = TP ./ (TP + FN);
        end
    end
end