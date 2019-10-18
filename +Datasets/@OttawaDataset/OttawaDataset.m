classdef OttawaDataset < Datasets.CDDataset
    methods
        function obj = OttawaDataset(data_path)
            obj@Datasets.CDDataset(data_path);
            
            obj.refStr = 'Ottawa SAR';
            
            loader_ = @Datasets.Loaders.tiffLoader;
            obj.loaders.t1 = loader_;
            obj.loaders.t2 = loader_;
            obj.loaders.ref = loader_;
        end
        function initFileSys(obj)
            obj.t1List = {fullfile(obj.dataPath, 'Ottawa1.tif')};
            obj.t2List = {fullfile(obj.dataPath, 'Ottawa2.tif')};
            obj.refList = {fullfile(obj.dataPath, 'Ottawa-ref.tif')};
        end
    end
end