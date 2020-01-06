classdef Kappa < Metrics.OA
    methods
        function obj = Kappa()
            obj@Metrics.OA();
        end
    end
    
    methods (Access=public)
        function kappa = gauge(obj, pred, gnd, ~)
            po = obj.gauge@Metrics.OA(pred, gnd, []);
            pe = obj.getPF(gnd)*obj.getPP(pred) + obj.getNF(gnd)*obj.getNP(pred);
            pe = pe / (numel(gnd).^2);
            kappa = (po - pe) / (1 - pe);
        end
    end
end