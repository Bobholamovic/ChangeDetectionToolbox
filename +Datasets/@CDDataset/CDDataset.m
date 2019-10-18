classdef (Abstract) CDDataset < handle
    properties (Access = public)
        refStr char = '';
    end
    properties(SetAccess=protected)
        % As cell arrays
        t1List = {};
        t2List = {};
        refList = {};
        % A function handle to the data loader
        loaders = struct();
    end
    properties(SetAccess=immutable)
        dataPath char = './';
    end
    methods
        function obj = CDDataset(data_path)
            if isdir(data_path)
                obj.dataPath = data_path;
            end
            
            % Initialize file system
            obj.initFileSys();
            
            % A simple check
            if ~isempty(obj.t1List) && (...
                    (ischar(obj.t1List{1}) && ~exist(obj.t1List{1}, 'file')) ...
                    || ...
                    (iscell(obj.t1List{1}) && ~exist(obj.t1List{1}{1}, 'file'))...
                    )
                error('Please check the validaty of the data directory');
            end
            
            % Set default loaders
            obj.loaders.t1 = @Datasets.Loaders.defaultLoader;
            obj.loaders.t2 = @Datasets.Loaders.defaultLoader;
            obj.loaders.ref = @Datasets.Loaders.defaultLoader;
        end
    end
    
    methods (Abstract, Access=public)
        initFileSys(obj);
    end
end