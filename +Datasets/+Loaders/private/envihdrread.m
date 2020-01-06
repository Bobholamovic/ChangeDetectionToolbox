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

function info = envihdrread(hdrfile)
% ENVIHDRREAD Reads header of ENVI image.
%   INFO = ENVIHDRREAD('HDR_FILE') reads the ASCII ENVI-generated image
%   header file and returns all the information in a structure of
%   parameters.
%
%   Example:
%   >> info = envihdrread('my_envi_image.hdr')
%   info =
%          description: [1x101 char]
%              samples: 658
%                lines: 749
%                bands: 3
%        header_offset: 0
%            file_type: 'ENVI Standard'
%            data_type: 4
%           interleave: 'bsq'
%          sensor_type: 'Unknown'
%           byte_order: 0
%             map_info: [1x1 struct]
%      projection_info: [1x102 char]
%     wavelength_units: 'Unknown'
%           pixel_size: [1x1 struct]
%           band_names: [1x154 char]
%
%   NOTE: This function is used by ENVIREAD to import data.

% Ian M. Howat, Applied Physics Lab, University of Washington
% ihowat@apl.washington.edu
% Version 1: 19-Jul-2007 00:50:57
% Modified by Felix Totir
%

fid = fopen(hdrfile);
while true
    line = fgetl(fid);
    if line == -1
        break
    else
        eqsn = findstr(line,'=');
        if ~isempty(eqsn)
            param = strtrim(line(1:eqsn-1));
            param(findstr(param,' ')) = '_';
            value = strtrim(line(eqsn+1:end));
            if isempty(str2num(value))
                if ~isempty(findstr(value,'{')) && isempty(findstr(value,'}'))
                    while isempty(findstr(value,'}'))
                        line = fgetl(fid);
                        
                        %for polSARpro
                        if line == -1
                            break;
                        end
                        value = [value,strtrim(line)];
                    end
                end
                eval(['info.',param,' = ''',value,''';'])
            else
                eval(['info.',param,' = ',value,';'])
            end
        end
    end
end
fclose(fid);

if isfield(info,'map_info')
    line = info.map_info;
    line(line == '{' | line == '}') = [];
    
    %originally: line = strtrim(split(line,','));
    %replaced by
    line=textscan(line,'%s', 'Delimiter',','); %behavior is not quite the same if "line" ends in ','
    line=line{:};
    line=strtrim(line);
    %
    
    info.map_info = [];
    info.map_info.projection = line{1};
    info.map_info.image_coords = [str2num(line{2}),str2num(line{3})];
    info.map_info.mapx = str2num(line{4});
    info.map_info.mapy = str2num(line{5});
    info.map_info.dx  = str2num(line{6});
    info.map_info.dy  = str2num(line{7});
    if length(line) == 9
        info.map_info.datum  = line{8};
        info.map_info.units  = line{9}(7:end);
    elseif length(line) == 11
        info.map_info.zone  = str2num(line{8});
        info.map_info.hemi  = line{9};
        info.map_info.datum  = line{10};
        info.map_info.units  = line{11}(7:end);
    end
    
    %part below comes form the original enviread
    %% Make geo-location vectors
    %     xi = info.map_info.image_coords(1);
    %     yi = info.map_info.image_coords(2);
    %     xm = info.map_info.mapx;
    %     ym = info.map_info.mapy;
    %     %adjust points to corner (1.5,1.5)
    %     if yi > 1.5
    %         ym =  ym + ((yi*info.map_info.dy)-info.map_info.dy);
    %     end
    %     if xi > 1.5
    %         xm = xm - ((xi*info.map_info.dy)-info.map_info.dx);
    %     end
    %
    %     info.x= xm + ((0:info.samples-1).*info.map_info.dx);
    %     info.y = ym - ((0:info.lines-1).*info.map_info.dy);
end

if isfield(info,'coordinate_system_string')
    line = info.coordinate_system_string;
    line(line == '{' | line == '}' | line == '"' | line == '[' ...
        | line == ']') = [];
    
    %originally: line = strtrim(split(line,','));
    %replaced by
    line=textscan(line,'%s', 'Delimiter',','); %behavior is not quite the same if "line" ends in ','
    line=line{:};
    line=strtrim(line);
    %
    
    info.coordinate_system = [];
    
    if contains(line{1},'UTM')
        info.coordinate_system.PROJCS = extractAfter(line{1},6);
        
        info.coordinate_system.GEOGCS = extractAfter(line{2},6);
        info.coordinate_system.DATUM = extractAfter(line{3},5);
        info.coordinate_system.SPHEROID = [];
        info.coordinate_system.SPHEROID.datum = extractAfter(line{4},8);
        info.coordinate_system.SPHEROID.a  = line{5};
        info.coordinate_system.SPHEROID.e  = line{6};
        info.coordinate_system.PRIMEM = extractAfter(line{7},6);
        info.coordinate_system.PMlongToGreenwich = line{8};
        info.coordinate_system.UNITGeo = extractAfter(line{9},4);
        info.coordinate_system.UNITGeo_value = line{10};
        
        info.coordinate_system.PROJECTION = extractAfter(line{11},10);
        info.coordinate_system.PARAMETER1 = extractAfter(line{12},9);
        info.coordinate_system.PARAMETER1_value = line{13};
        info.coordinate_system.PARAMETER2 = extractAfter(line{14},9);
        info.coordinate_system.PARAMETER2_value = line{15};
        info.coordinate_system.PARAMETER3 = extractAfter(line{16},9);
        info.coordinate_system.PARAMETER3_value = line{17};
        info.coordinate_system.PARAMETER4 = extractAfter(line{18},9);
        info.coordinate_system.PARAMETER4_value = line{19};
        info.coordinate_system.PARAMETER5 = extractAfter(line{20},9);
        info.coordinate_system.PARAMETER5_value = line{21};
        info.coordinate_system.UNITPro = extractAfter(line{22},4);
        info.coordinate_system.UNITPro_value = line{23};
        
    elseif strcmp(info.map_info.projection, 'Geographic Lat/Lon')
        info.coordinate_system.GEOGCS = extractAfter(line{1},6);
        info.coordinate_system.DATUM = extractAfter(line{2},5);
        info.coordinate_system.SPHEROID = [];
        info.coordinate_system.SPHEROID.datum = extractAfter(line{3},8);
        info.coordinate_system.SPHEROID.a  = line{4};
        info.coordinate_system.SPHEROID.e  = line{5};
        info.coordinate_system.PRIMEM = extractAfter(line{6},6);
        info.coordinate_system.PMlongToGreenwich = line{7};
        info.coordinate_system.UNITGeo = extractAfter(line{8},4);
        info.coordinate_system.UNITGeo_value = line{9};
    end
    
end


if isfield(info,'pixel_size')
    line = info.pixel_size;
    line(line == '{' | line == '}') = [];
    
    %originally: line = strtrim(split(line,','));
    %replaced by:
    line=textscan(line,'%s','Delimiter',','); %behavior is not quite the same if "line" ends in ','
    line=line{:};
    line=strtrim(line);
    
    info.pixel_size = [];
    info.pixel_size.x = str2num(line{1});
    info.pixel_size.y = str2num(line{2});
    info.pixel_size.units = line{3}(7:end);
end

% function split is only used when replacements above do not work
% function A = split(s,d)
%This function by Gerald Dalley (dalleyg@mit.edu), 2004
% A = {};
% while (~isempty(s))
%     [t,s] = strtok(s,d);
%     A = {A{:}, t};
% end
