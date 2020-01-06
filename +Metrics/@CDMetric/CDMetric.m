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
            validateattributes(im, {'uint8', 'logical'}, {});
            if isa(im, 'uint8')
                im_logic = Utilities.toLogicalMask(im);
            else
                im_logic = im;
            end
        end
        
        function tp = getTP(pred, gnd)
            if ndims(gnd) == 3
                gnd = gnd(:,:,1);
                tp = sum(pred(:) & gnd(:));
            else
                tp = sum(pred(:) & gnd(:));
            end
        end
        
        function fp = getFP(pred, gnd)
            if ndims(gnd) == 3
                gnd = gnd(:,:,2);
                fp = sum(pred(:) & gnd(:));
            else
                fp = sum(pred(:) & ~gnd(:));
            end
        end
        
        function tn = getTN(pred, gnd)
            if ndims(gnd) == 3
                gnd = gnd(:,:,2);
                tn = sum(~pred(:) & gnd(:));
            else
                tn = sum(~pred(:) & ~gnd(:));
            end
        end
        
        function fn = getFN(pred, gnd)
            if ndims(gnd) == 3
                gnd = gnd(:,:,1);
                fn = sum(~pred(:) & gnd(:));
            else
                fn = sum(~pred(:) & gnd(:));
            end
        end
        
        function pf = getPF(gnd)
            % Get the number of positive facts
            if ndims(gnd) == 3
                gnd = gnd(:,:,1);
            end
            pf = sum(gnd(:));
        end
        
        function nf = getNF(gnd)
            % Negative facts
            if ndims(gnd) == 3
                gnd = ~gnd(:,:,2);
            end
            nf = sum(~gnd(:));
        end
        
        function pp = getPP(pred)
            % Get the number of positive predictions
            pp = sum(pred(:));
        end
        
        function np = getNP(pred)
            % Negative predictions
            np = sum(~pred(:));
        end
        
        function [ref_cmb, mask] = combineRefs(ref)
            assert(ndims(ref) == 3)
            none = 2;
            ref_cmb = uint8(none*ones(size(ref,1), size(ref,2)));
            ref_cmb(ref(:,:,1)) = 1;
            ref_cmb(ref(:,:,2)) = 0;
            mask = (ref_cmb < none);
        end
    end
end