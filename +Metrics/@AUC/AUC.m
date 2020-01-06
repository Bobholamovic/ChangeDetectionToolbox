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
                cdMap2d = Utilities.mergeAvg(cd_map);
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
            [DISorted, idxs] = sort(cdMap2d(:), 'descend');
            n = length(DISorted);
            obj.fprs = zeros(n, 1);
            obj.tprs = zeros(n, 1);
            labelSorted = ref(idxs);
            notLabelSorted = ~labelSorted;
            sumFPRN = notLabelSorted(1);
            fprj = 2;
            sumFPRD = sum(notLabelSorted);
            sumTPRN = labelSorted(1);
            tprj = 2;
            sumTPRD = sum(labelSorted);
            thre = DISorted(1);
            obj.fprs(1) = sumFPRN / sumFPRD;
            obj.tprs(1) = sumTPRN / sumTPRD;
            for ii = 2:n
                if thre == DISorted(ii)
                    obj.fprs(ii) = obj.fprs(ii-1);
                    obj.tprs(ii) = obj.tprs(ii-1);
                else
                    sumFPRN = sumFPRN + sum(notLabelSorted(fprj:ii));
                    sumTPRN = sumTPRN + sum(labelSorted(tprj:ii));
                    obj.fprs(ii) = sumFPRN / sumFPRD;
                    obj.tprs(ii) = sumTPRN / sumTPRD;
                    fprj = ii+1;
                    tprj = ii+1;
                    thre = DISorted(ii);
                end
            end
            % Approximate the value of the definite integral
            auc = sum(diff(obj.fprs) .* obj.tprs(2:end));
        end
        
        function fig = plotROC(obj, varargin)
            % Note that this method has to be invoked after obj.update is
            % called
            fig = figure('Name', 'ROC Curve');
            plot(obj.fprs, obj.tprs, 'b-', 'LineWidth', 2, varargin{:});
            grid on,
            title(sprintf('AUC=%.4f', obj.val(end))),
            xlabel('FPR'),
            ylabel('TPR'),
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