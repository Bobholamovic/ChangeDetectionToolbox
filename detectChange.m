function varargout = detectChange(alg_cd, config_alg_cd, alg_thre, config_alg_thre, varargin)
%detectChange Perform change detection on a given image pair or data folder.
%
% [CM, DI] = detectChange(alg_cd, config_alg_cd, alg_thre, config_alg_thre, path_t1, path_t2)
%
% returns the change map CM and the difference image DI. alg_cd specifies the name of the CD
% algorithm to use, and config_alg_cd is a cell array that contains the arguments to construct
% the CDAlg object. alg_thre specifies the name of the thresholding algorithm, with
% config_alg_thre being its corresponding configs. path_t1 and path_t2 are the absolute or
% relative paths to the input bi-temporal images.
%
% [CMs, DIs] = detectChange(alg_cd, config_alg_cd, alg_thre, config_alg_thre, data_dir)
%
% handles an image folder, which is specified by data_dir. The image folder
% should be structured as follows:
% |- DATA_DIR
% |     |- t1
% |     |- t2
% |     |_ gt
% where the gt subfolder is optional. t1 contains images acquired at the first time instance
% while t2 at the second time instance. see Datasets.Folder for more details. Note that the CMs
% and the DIs will be returned in cell arrays.
%
% [CM, DI, results] = detectChange(alg_cd, config_alg_cd, alg_thre, config_alg_thre, path_t1,
% path_t2, path_ref, metrics, configs_metrics)
%
% returns evaluation results, additionally. To enable the evaluation metrics, you will have
% to specify the path to the reference image, path_ref, and the names of the metrics to use.
% All names ought to be contained in the cell array metrics, and there should also be
% configuration cells for each metric, which are nested in the cell configs_metrics.
%
% [CMs, DIs, results] = detectChange(alg_cd, config_alg_cd, alg_thre, config_alg_thre, data_dir,
% metrics, configs_metrics)
%
% evaluates each image pair in a folder.In this case, the gt subfolder is required.
%

% Create instances
algCD = Algorithms.(alg_cd)(config_alg_cd{:});
algThre = ThreAlgs.(alg_thre)(config_alg_thre{:});
% Choose the right entrance
if nargin == 9
    % varargin being path_t1, path_t2, path_ref, metrics, and
    % config_metrics
    varargout = cell(1,3);
    [varargout{:}] = cd4Pair_(algCD, algThre, varargin{:});
elseif nargin == 7
    % varargin being dir_, metrics, and config_metrics
    varargout = cell(1,3);
    [varargout{:}] = cd4Dir_(algCD, algThre, varargin{:});
elseif nargin == 6
    % varargin being path_t1 and path_t2
    varargout = cell(1,2);
    [varargout{:}] = cd4Pair_(algCD, algThre, varargin{:}, '', {}, {});
elseif nargin == 5
    % varargin being dir_
    [varargout{1}, varargout{2}] = cd4Dir_(algCD, algThre, varargin{:}, {}, {});
else
    error('Wrong number of input arguments');
end
end

function [CMs, DIs, results] = cd4Dir_(alg_cd, alg_thre, dir_, metrics, configs)
dataset = Datasets.Folder(dir_);
iterator = Datasets.CDDIterator(dataset);

% Create metric instances
nMetrics = length(metrics);
meters = cell(1, nMetrics);
for ii = 1:nMetrics
    meters{ii} = Metrics.(metrics{ii})(configs{ii}{:});
end

DIs = {}; CMs = {};
% Do loop
while(iterator.hasNext())
    % Fetch data
    [t1, t2, ref] = iterator.nextChunk();
    % Check rank
    getRank = @(x) rank(reshape(double(x), size(x, 1)*size(x, 2), size(x, 3)));
    if getRank(t1) <= 1 || getRank(t2) <= 1
        warning('The rank of the input image is detected to be lower than 2.');
    end
    DI = alg_cd.detectChange(t1, t2);
    CM = alg_thre.segment(DI);
    if nMetrics > 0 %&& ~isempty(ref)
        % Update value
        cellfun(@(obj) obj.update(CM, ref, DI), meters);
        % Show logs
        for ii = 1:nMetrics
            m = meters{ii};
            fprintf('type: %s\n', metrics{ii});
            fprintf('\tnewest: %f\n', m.val(end));
            fprintf('\taverage: %f\n', m.avg);
        end
        fprintf('\n');
    end
    DIs = [DIs, DI];
    CMs = [CMs, CM];
end

results = struct();
for ii = 1:nMetrics
    results.(metrics{ii}) = meters{ii}.avg;
end
end

function [CM, DI, results] = cd4Pair_(alg_cd, alg_thre, path_t1, path_t2, path_ref, metrics, configs)
% Load data
imT1 = readFile__(path_t1);
imT2 = readFile__(path_t2);

% Check data redundancy
getRank = @(x) rank(reshape(double(x), size(x, 1)*size(x, 2), size(x, 3)));
if getRank(imT1) <= 1 || getRank(imT2) <= 1
    warning('The rank of the input image is detected to be lower than 2.');
end

DI = alg_cd.detectChange(imT1, imT2);
CM = alg_thre.segment(DI);

if  ~isempty(metrics)% && ~isempty(path_ref)
    ref = readFile__(path_ref);
    % Create metric instances
    nMetrics = length(metrics);
    meters = cell(1, nMetrics);
    for ii = 1:nMetrics
        meters{ii} = Metrics.(metrics{ii})(configs{ii}{:});
        meters{ii}.update(CM, ref, DI);
        results.(metrics{ii}) = meters{ii}.val;
    end
end

    function im = readFile__(path_)
        try
            % Try to read via default loader
            im = Datasets.Loaders.defaultLoader(path_);
        catch ME
            % Otherwise, read as envi file
            if strcmp(ME.identifier, 'MATLAB:imagesci:imread:fileFormat')
                im = Datasets.Loaders.enviLoader(path_);
            else
                rethrow(ME);
            end
        end
    end
end