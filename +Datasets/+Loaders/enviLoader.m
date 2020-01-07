function [im, info] = enviLoader(im_path)
% Slightly modified on https://github.com/ZjxRS/ImageProcess/tree/master/Matlab/ENVI_ReadAndWrite
%
%Original version by Ian Howat, Ohio State Universtiy, ihowat@gmail.com
%Thanks to Yushin Ahn and Ray Jung
%Heavily modified by Felix Totir.

% The header file and the data file should be in the same folder and differ
% only in extension name
[pathStr, name, ~] = fileparts(im_path);
hdr_path = fullfile(pathStr, [name, '.hdr']);

info=envihdrread(hdr_path);
im=envidataread(im_path,info);

end