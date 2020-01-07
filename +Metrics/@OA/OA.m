classdef OA < Metrics.CDMetric
    % Overall accuracy
    methods (Access=public)
        function acc = gauge(obj, pred, gnd, ~)
            TP = obj.getTP(pred, gnd);
            FP = obj.getFP(pred, gnd);
            TN = obj.getTN(pred, gnd);
            FN = obj.getFN(pred, gnd);
            acc = (TP + TN) / (TP + TN + FP + FN);
        end
    end
end