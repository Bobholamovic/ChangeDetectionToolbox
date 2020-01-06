%{
MIT License

Copyright (c) 2018 ZjxRS

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
%}
% This is lifted from https://github.com/ZjxRS/ImageProcess/tree/master/Matlab/ENVI_ReadAndWrite

function D=envidataread(datafile,info)
%ENVIDATAREAD Reads data of ENVI image file according to ENVI image file header information.
%D=ENVIDATAREAD(DATAFILE,INFO) provides image data (D).
%D will be in whatever number format (double, int, etc.) as in the ENVI
%file.

%Original version by Ian Howat, Ohio State Universtiy, ihowat@gmail.com
%Thanks to Yushin Ahn and Ray Jung
%Heavily modified by Felix Totir.
%

if nargin < 2
    error('You must specify the information about data (output of envihdrread)');
end

%-improved- assert(info.header_offset==0,'Non-zero header offset not supported');

%% Set binary format parameters
switch info.byte_order
    case {0}
        machine = 'ieee-le';
    case {1}
        machine = 'ieee-be';
    otherwise
        machine = 'n';
end

iscx=false; %if it is complex
switch info.data_type
    case {1}
        format = 'uint8';
    case {2}
        format= 'int16';
    case{3}
        format= 'int32';
    case {4}
        format= 'float';
    case {5}
        format= 'double';
    case {6}
        iscx=true;
        format= 'float';
    case {9}
        iscx=true;
        format= 'double';
    case {12}
        format= 'uint16';
    case {13}
        format= 'uint32';
    case {14}
        format= 'int64';
    case {15}
        format= 'uint64';
    otherwise
        error(['File type number: ',num2str(dtype),' not supported']);
end

% *** BSQ Format ***
% [Band 1]
% R1: C1, C2, C3, ...
% R2: C1, C2, C3, ...
%  ...
% RN: C1, C2, C3, ...
%
% [Band 2]
%  ...
% [Band N]

% *** BIL Format ***
% [Row 1]
% B1: C1, C2, C3, ...
% B2: C1, C2, C3, ...
%
%  ...
% [Row N]

% *** BIP Format ***
% Row 1
% C1: B1 B2 B3, ...
% C2: B1 B2 B3, ...
% ...
% Row N

n = info.lines*info.samples*info.bands;

fid=fopen(datafile,'r');
fread(fid,info.header_offset,'uint8',0,machine); %we skip the header
if ~iscx
    if strcmp(info.file_type, 'ENVI Classification')
        D = fread(fid,n,'uint8',0,machine);
    else
        D = fread(fid,n,format,0,machine); %alternatively, multibandreader (matlab function) might be used
    end
else
    D = fread(fid,2*n,format,0,machine); %alternatively, multibandreader (matlab function) might be used
    D = complex(D(1:2:end),D(2:2:end));
end
fclose(fid);

switch lower(info.interleave)
    case {'bsq'}
        D = reshape(D,[info.samples,info.lines,info.bands]);
        D = permute(D,[2,1,3]);
    case {'bil'}
        D = reshape(D,[info.samples,info.bands,info.lines]);
        D = permute(D,[3,1,2]);
    case {'bip'}
        D = reshape(D,[info.bands,info.samples,info.lines]);
        D=permute(D,[3,2,1]);
end
