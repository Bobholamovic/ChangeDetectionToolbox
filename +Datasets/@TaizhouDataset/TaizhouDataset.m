classdef TaizhouDataset < Datasets.CDDataset
    properties
        sampled logical=true;
    end
    methods
        function obj = TaizhouDataset(data_path, sampled)
            obj@Datasets.CDDataset(data_path);
            
            obj.refStr = 'Taizhou';
            
            if exist('sampled', 'var')
                obj.sampled = sampled;
            end
            
            obj.loaders.t1 = @Datasets.Loaders.tiffLoader;
            obj.loaders.t2 = @Datasets.Loaders.tiffLoader;
            
            if obj.sampled
                obj.loaders.ref = {@Datasets.Loaders.bmpLoader, @Datasets.Loaders.bmpLoader};
                obj.refList = {{fullfile(obj.dataPath, 'TaizhouChange_blackWhite.bmp'), ...
                    fullfile(obj.dataPath, 'TaizhouChange_blackWhite_unchange.bmp')}...
                    };
            else
                obj.loaders.ref = @Datasets.Loaders.bmpLoader;
                obj.refList = {fullfile(obj.dataPath, 'TaizhouChange_blackWhite.bmp')};
            end
        end
        function initFileSys(obj)
            obj.t1List = {fullfile(obj.dataPath, '2000TM.tif')};
            obj.t2List = {fullfile(obj.dataPath, '2003TM.tif')};
        end
    end
end