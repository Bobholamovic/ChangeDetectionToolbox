classdef BernDataset < Datasets.CDDataset
    methods
        function obj = BernDataset(data_path)
            obj@Datasets.CDDataset(data_path);
            
            obj.refStr = 'Bern SAR';
            
            loader_ = @Datasets.Loaders.tiffLoader;
            obj.loaders.t1 = loader_;
            obj.loaders.t2 = loader_;
            obj.loaders.ref = loader_;
        end
        function initFileSys(obj)
            obj.t1List = {fullfile(obj.dataPath, 'Bern1.tif')};
            obj.t2List = {fullfile(obj.dataPath, 'Bern2.tif')};
            obj.refList = {fullfile(obj.dataPath, 'reference_Berma.tif')};
        end
    end
end