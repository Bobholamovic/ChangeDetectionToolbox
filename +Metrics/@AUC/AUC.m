classdef AUC < Metrics.CDMetric
    properties (Access=public)
        fprs;
        tprs;
    end
    
    methods
        function auc = gauge(obj, ~, label, cd_map)
            % The implementation refers to this blog
            % https://www.cnblogs.com/huadongw/p/5495004.html
            if size(cd_map, 3) > 1
                % Average pooling
                cdMap2d = mean(cd_map, 3);
            else
                cdMap2d = cd_map;
            end
            if size(label, 3) > 1
                [ref, mask] = obj.combineRefs(label);
                cdMap2d = cdMap2d(mask);
                ref = logical(ref(mask));
            else
                ref = label;
            end
            [~, idcs] = sort(cdMap2d(:), 'descend');
            labelSorted = ref(idcs);
            obj.fprs = cumsum(~labelSorted) / sum(~labelSorted);
            obj.tprs = cumsum(labelSorted) / sum(labelSorted);
            % Approximate the value of the definite integral
            auc = sum(diff(obj.fprs) .* obj.tprs(2:end));
        end
        
        function fig = plotROC(obj, varargin)
            % Note that this method has to be invoked after obj.update is
            % called
            fig = figure('Name', 'ROC Curve');
            grid on, 
            title(sprintf('AUC=%.2f%%', obj.val(end))), 
            xlabel('FPR'), 
            ylabel('TPR'),
            plot(obj.fprs, obj.tprs, 'b-', 'LineWidth', 2, varargin{:});
            hold on, 
            plot([0.0, 1.0], [0.0, 1.0], '--k'),
            hold off;
        end
        
        function reset(obj)
            reset@Metrics.CDMetric(obj);
            obj.fprs = [];
            obj.tprs = [];
        end
    end
end