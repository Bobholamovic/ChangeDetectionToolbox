classdef (Abstract) CDMetric < handle
    properties (Access=public)
        val;
        num;
    end
    
    properties (Dependent)
        avg;
        sum;
    end
        
    methods
        function obj = CDMetric()
            reset(obj);
        end
        
        function reset(obj)
            obj.val = [];
            obj.num = 0;
        end
        
        function update(obj, pred, gnd, cd_map)
            p = obj.preprocess(pred);
            g = obj.preprocess(gnd);
            obj.val = [obj.val, gauge(obj, p, g, cd_map)];
            obj.num = obj.num + 1;
        end
        
        function a = get.avg(obj)
            if obj.num == 0
                a = 0;
            else
                a = obj.sum / obj.num;
            end
        end
        
        function s = get.sum(obj)
            s = builtin('sum', obj.val);
        end
    end
    
    methods (Abstract, Access=public)
        index = gauge(obj,~, ~, ~);
    end
    
    methods (Static)
        function im_logic = preprocess(im)
            validateattributes(im, {'uint8', 'logical'}, {'2d'});
            if isa(im, 'uint8')
                im_logic = (im > min(im(:)));
            else
                im_logic = im;
            end
        end
        
        function tp = getTP(pred, gnd)
            tp = sum(pred(:) & gnd(:));
        end
        
        function fp = getFP(pred, gnd)
            fp = sum(pred(:) & ~gnd(:));
        end   
        
        function tn = getTN(pred, gnd)
            tn = sum(~pred(:) & ~gnd(:));
        end
        
        function fn = getFN(pred, gnd)
            fn = sum(~pred(:) & gnd(:));
        end
    end
end