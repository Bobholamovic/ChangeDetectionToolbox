classdef (Abstract) CDAlg
    properties
        algName char = '';
        refStr char = '';
    end
    methods
        function obj = CDAlg(name, ref)
            obj.algName = name;
            obj.refStr = ref;
        end
    end
    methods (Abstract)
        change_map = detectChange(obj, ~, ~);
    end
end