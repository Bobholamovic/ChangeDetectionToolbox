classdef OSCDDataset < Datasets.CDDataset
    methods
        function obj = OSCDDataset(data_path)
            obj@Datasets.CDDataset(data_path);
            
            obj.refStr = 'Onera Satellite Change Detection dataset';
            
            obj.loaders.ref = @Datasets.Loaders.tiffLoader;  % Use .tif labels
            %
            % For test phase declare a new subclass that extends
            % OSCDDataset and change some bahaviours
        end
        function initFileSys(obj)
            imgFolder = fullfile(obj.dataPath, 'Onera Satellite Change Detection dataset - Images');
            labFolder = fullfile(obj.dataPath, 'Onera Satellite Change Detection dataset - Train Labels');
            % Read folder names (training set only)
            fid = fopen(fullfile(imgFolder, 'train.txt'));
            names = fscanf(fid, '%s');
            fclose(fid);
            names = split(names, ',');
            
            for ii = 1:length(names)
                % Lists contain only the resampled-at-10m-resolution
                % images, i.e. the 'rect' ones
                name = names{ii};
                subFolder = fullfile(imgFolder, name, 'imgs_1_rect');
                bands = dir(fullfile(subFolder, '*.tif'));
                % Sorted in alphabetical order
                bands = sort(string({bands.name}), 'ascend');
                for jj = 1:length(bands)
                    obj.t1List{ii}{jj} = fullfile(subFolder, char(bands(jj)));
                end
                
                subFolder = fullfile(imgFolder, name, 'imgs_2_rect');
                bands = dir(fullfile(subFolder, '*.tif'));
                % Corresponding to t1
                bands = sort(string({bands.name}), 'ascend');
                for jj = 1:length(bands)
                    obj.t2List{ii}{jj} = fullfile(subFolder, char(bands(jj)));
                end
                
                obj.refList{ii} = fullfile(labFolder, name, sprintf('cm\\%s-cm.tif', name));
            end
            
        end
    end
end