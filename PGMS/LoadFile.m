function varargout = LoadFile(varargin)
global u
% varargout={};
% global varargout
if length(u) >= 2
    if isfield(u(2),'uid')
%         u(2).String = get(u(2).uid,'String');
%         set(u(2).uid,'String','Busy...');
    end
end
filename=varargin{1};
fid = fopen(filename);
fline = fgetl(fid);
while fline(1) ~= '0'
    flino = fline;
    fline = fgetl(fid);
    ftmp = regexp(flino,'\t', 'split');
    if isempty(fline)
        fline = char(0);
    end
    if length(flino) > 3
        switch flino(1:3)
            case 'Sta'
                varargout{1}.start = ftmp{2};
            case 'Rat'
                varargout{1}.rate = str2double(ftmp{2});
            case 'Siz'
                varargout{1}.size = str2double(ftmp{2});
        end
    end
end
format = '%f';
for k=1:length(regexp(fline,'\t','start'))
    format = [ format '\t%f']; %#ok;
end
format = [ format '\n' ];
k=1;
A=[];
while ~feof(fid)
    fline = strrep(fline, ',', '.');
    A(k,:)= sscanf(fline,format)'; %#ok;
    fline = fgetl(fid);
    k = k + 1;
end
fclose(fid);
varargout{1}.data = A;
varargout{1}.head = regexp(flino, '\t', 'split');
if length(u) >= 2
    if isfield(u(2),'uid')
%         set(u(2).uid,'String',u(2).String);
    end
end
end