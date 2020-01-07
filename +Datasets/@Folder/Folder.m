classdef Folder < Datasets.CDDataset
    properties (Constant)
        dirT1 = 't1';
        dirT2 = 't2';
        dirGT = 'gt';
        fmt = {'.png', '.bmp', '.tif'}  % Reserved
    end
    methods
        function obj = Folder(data_path)
            obj@Datasets.CDDataset(data_path)
        end
        function initFileSys(obj)
            % Note that in this initial version, Folder will process
            % ALL non-dir files with any extension name in the subdirs
            %
            % Note that the correspondance is deduced from the alphabetical
            % order of the files inside each subdir, which means that you
            % have to ensure when files in a folder are sorted
            % alphabetically, then the first readable file in t1 subdir
            % corresponds to the first one in t2 subdir, and also the first
            % one in gt subdir, etc.
            listingT1 = dir(fullfile(obj.dataPath, obj.dirT1));
            listingT2 = dir(fullfile(obj.dataPath, obj.dirT2));
            listingGT = dir(fullfile(obj.dataPath, obj.dirGT));
            obj.t1List = obj.getFileList__(listingT1);
            obj.t2List = obj.getFileList__(listingT2);
            obj.refList = obj.getFileList__(listingGT);
        end
    end
    methods(Access=private)
        function paths = getFileList__(obj, listing)
            % Sort in ascending order to ensure the alignment of files from
            % different subfolders
            [names, idxs] = sort({listing.name});
            folders = {listing.folder};
            folders = folders(idxs);
            flags = {listing.isdir};
            flags = flags(idxs);
            paths = {};
            for ii = 1:size(names, 2)
                if ~flags{ii}
                    paths = [paths, fullfile(folders{ii}, names{ii})];
                end
            end
        end
    end
end