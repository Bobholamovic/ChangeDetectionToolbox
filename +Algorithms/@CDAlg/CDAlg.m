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
        DI = detectChange(obj, ~, ~);
    end
end