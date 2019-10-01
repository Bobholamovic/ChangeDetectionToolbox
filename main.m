%% Main script
clear all, close all;

%% Global options
GO_SHOW_CHANGE = false;
GO_SHOW_MASK = false;
GO_SHOW_ROC_CURVE = false;
GO_CONFIG_ROC = {};
GO_VERBOSE = true;
GO_SAVE_RESULTS = false;
GO_OUT_FILE_PATH = './results.mat';

PAUSE_EACH_ITER_ = GO_SHOW_CHANGE | GO_SHOW_MASK | GO_SHOW_ROC_CURVE;

%% Opt and configure the IMPORTANT ones
%
% Available algorithms: CVA, DPCA, ImageDiff, ImageRatio, Image Regr,
% IRMAD, KPCA, MAD, MBPCA, PCDA
%
% Available datasets: BernDataset, TaizhouDataset
%
% Available binarization algorithms: FixedThre, KMeans, OTSU
%
% Available metrics: Acc, AUC, CDMetric, FMeasure, OA, Recall
%
ALG = 'ImageDiff'
DATASET = 'BernDataset'
THRE_ALG = 'OTSU'
METRICS = {'AUC', 'OA', 'Recall'}

CONFIG_ALG = {};
% CONFIG_DATASET = {'E:\\科研资料\\项目\\变化监测\\Change Detection Code\\data\\Taizhou'};
CONFIG_DATASET = {'E:\\科研资料\\参考资料\\解亚超\\数据\\Bern'};
CONFIG_THRE_ALG = {};
CONFIG_METRICS = {{}, {}, {}};

%% Construct objects
% This might be unsafe, yet can't think of a better way
% I should read some docs on the introspection machenism
constrStr = @(pkg, cls, con) [pkg, '.', cls, '(', con, '{:})']; % var{:} can be seen as kinda unpacking?
alg = eval(constrStr('Algorithms', ALG, 'CONFIG_ALG'));
dataset = eval(constrStr('Datasets', DATASET, 'CONFIG_DATASET'));
iterDS = Datasets.CDDIterator(dataset);
threAlg = eval(constrStr('ThreAlgs', THRE_ALG, 'CONFIG_THRE_ALG'));
nMetrics = length(METRICS);
metrics = cell(1, nMetrics);
for ii = 1:nMetrics
    metrics{ii} = eval(constrStr('Metrics', METRICS{ii}, 'CONFIG_METRICS{ii}'));
end

%% Main loop
while(iterDS.hasNext())
    % Fetch data
    [t1, t2, ref] = iterDS.nextChunk();
    % Make change map
    changeMap = alg.detectChange(t1, t2);
    % Segment
    segMap = threAlg.segment(changeMap);
    % Measure
    cellfun(@(obj) obj.update(segMap, ref, changeMap), metrics);
    
    if GO_VERBOSE
        for ii = 1:nMetrics
            m = metrics{ii};
            fprintf('type: %s\n', METRICS{ii});
            fprintf('\tnewest: %f\n', m.val(end));
            fprintf('\taverage: %f\n', m.avg);
        end
        fprintf('\n')
    end
    
    if PAUSE_EACH_ITER_
        if GO_SHOW_CHANGE
            figure('Name', 'Change Map'),
            imshow(changeMap);
        end
        
        if GO_SHOW_MASK
            figure('Name', 'Change Mask'),
            imshow(segMap);
        end
        
        if GO_SHOW_ROC_CURVE
            if ~exist('aucer', 'var')
                [~, loc] = ismember('AUC', METRICS);
                if loc == 0
                    error('AUC was not included in the desired metrics');
                end
                aucer = metrics{loc};
            end
            aucer.plotROC(GO_CONFIG_ROC{:});
        end
        
        pause
    end
end

%% Collate and save results
results = struct('name', ALG, 'threAlg', THRE_ALG, 'dataset', DATASET);
for ii = 1:nMetrics
    results = setfield(results, METRICS{ii}, metrics{ii}.avg);
end

if GO_SAVE_RESULTS
    save(GO_OUT_FILE_PATH, 'results');
end
