classdef CDDIterator < handle
    properties(Access=protected)
        index_ = 0;
        t1List_;
        t2List_;
        refList_;
        loaders_;
    end
    
    properties(Access=public)
        len;
    end
    
    methods
        function obj = CDDIterator(dataset)
            if ~isa(dataset, 'Datasets.CDDataset')
                error('Please give a CDDataset object')
            end
            % Rely on the copy-on-write mechanism
            % Do not change the dataset object
            obj.t1List_ = dataset.t1List;
            obj.t2List_ = dataset.t2List;
            obj.refList_ = dataset.refList;
            obj.loaders_ = dataset.loaders;
            obj.len = length(dataset.refList);
        end
        
        function reset(obj)
            obj.index_ = 0;
        end
        
        function state = hasNext(obj)
            if obj.index_ == obj.len
                state = false;
            else
                state = true;
            end
        end
        
        function [t1, t2, ref] = next(obj)
            obj.index_ = obj.index_ + 1;
            t1 = obj.t1List_{obj.index_};
            t2 = obj.t2List_{obj.index_};
            ref = obj.refList_{obj.index_};
        end
        
        function [im_t1, im_t2, im_ref] = nextChunk(obj)
            [t1, t2, ref] = next(obj);
            im_t1 = obj.fetch(obj.loaders_.t1, t1);
            im_t2 = obj.fetch(obj.loaders_.t2, t2);
            if iscell(ref)
                im_ref(:,:,1) = feval(obj.loaders_.ref{1}, ref{1});
                im_ref(:,:,2) = feval(obj.loaders_.ref{2}, ref{2});
            else
                im_ref = feval(obj.loaders_.ref, ref);
            end
        end
        
        function [im] = fetch(obj, loader, p)
            if iscell(p)
                for ii = 1:length(p)
                    im(:,:,ii) = feval(loader, p{ii});
                end
            else
                im = feval(loader, p);
            end
        end
        
    end
end