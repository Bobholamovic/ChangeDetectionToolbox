classdef (Abstract) ThreAlg
    properties
        algName = '';
    end
    methods (Abstract)
        seg_map = segment(obj, change_map);
    end
end