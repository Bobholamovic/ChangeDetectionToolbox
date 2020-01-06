classdef AirChangeDataset < Datasets.CDDataset
    methods
        function obj = AirChangeDataset(data_path)
            obj@Datasets.CDDataset(data_path);
            
            obj.refStr = 'SZTAKI AirChange Benchmark set';
            
            loader_ = @Datasets.Loaders.bmpLoader;
            obj.loaders.t1 = loader_;
            obj.loaders.t2 = loader_;
            obj.loaders.ref = loader_;
        end
        function initFileSys(obj)
            % Initiate with Archieve
            obj.t1List = {fullfile(obj.dataPath, 'Archieve\\im1.bmp')};
            obj.t2List = {fullfile(obj.dataPath, 'Archieve\\im2.bmp')};
            obj.refList = {fullfile(obj.dataPath, 'Archieve\\gt.bmp')};
            
            % Push-back Szada
            for ii = 1:7
                % Absolute path
                dirStr = fullfile(obj.dataPath, sprintf('Szada\\%d',ii));
                obj.t1List{end+1} = fullfile(dirStr, 'im1.bmp');
                obj.t2List{end+1} = fullfile(dirStr, 'im2.bmp');
                obj.refList{end+1} = fullfile(dirStr, 'gt.bmp');
            end
            
            % Finally Tiszadob
            for ii = 1:5
                dirStr = fullfile(obj.dataPath, sprintf('Tiszadob\\%d',ii));
                obj.t1List{end+1} = fullfile(dirStr, 'im1.bmp');
                obj.t2List{end+1} = fullfile(dirStr, 'im2.bmp');
                obj.refList{end+1} = fullfile(dirStr, 'gt.bmp');
            end
        end
    end
end