function [amp_map, ang_map] = detectChange(obj, t1, t2)
% This method returns an amplitude map and a angle map as a byproduct.
% When called in this form:
%   change_map = detectChange(obj, t1, t2)
% Only the amp_map will be caught and copied to change_map, while the
% ang_map deserted.
%
% Unlike many counterparts, this implementation perfoms (t2 - t1)
% insead of (t1 - t2) as I think the former one easier for
% interpretation in vectors
diffMap = double(t2) - double(t1);
amp_map = sqrt(sum(diffMap.^2, 3));
ang_map = (diffMap ./ amp_map);
end

