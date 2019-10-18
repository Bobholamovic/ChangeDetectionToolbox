classdef (Abstract) ThreAlg
    properties
        algName = '';
    end
    methods (Abstract)
        CM = segment(obj, DI);
    end
end