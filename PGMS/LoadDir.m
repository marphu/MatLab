function LoadDir( varargin )
global A DirName FileMask
UP = userpath();
s=[UP(1:end-1) '/PGMS.set.mat'];
if exist(s) == 2 %#ok
    load(s,'DirName','FileMask');
end
if isempty(DirName)
    if ~isempty(varargin) && ischar(varargin{1})
        DirName = varargin{1};
    else
        DirName = pwd;
    end
else
    if ~isempty(varargin) && ischar(varargin{1})
        DirName = varargin{1};
    end
end
if ~isempty(varargin) && length(varargin)>1 && varargin{2}==1
    d = DirName;
else
    d = uigetdir(DirName);
end
if d ~= 0
    DirName = d;
else
    return;
end
if isempty(FileMask)
    if ~isempty(varargin)
        if length(varargin) > 1
            FileMask=varargin{2};
        else
            FileMask='*.txt';
        end
    else
        FileMask='*.txt';
    end
end
% if ~iscell(A)
%     FileMask
% end
F = {FileMask;'*.txt';'test_*.txt'};
if ~isempty(varargin) && length(varargin)>1 && varargin{2}==1
    n=3;
    A=[];
else
    n = listdlg('SelectionMode','single', 'ListString', F);
end
if isempty(n)
    n = 1; %#ok;
    return;
end
FileMask = F{n};
save(s,'DirName','FileMask');
s = horzcat(DirName, '\', strrep(FileMask, '*', ''), '.mat');
% size(s)
% display(s);
if exist(s) == 2 %#ok;
    load(s);
end
d = dir([DirName '\' FileMask]);
if isempty(A)
    A = d;
end

% display([DirName '\' FileMask]);
if length(A) ~= length(d)
    a=length(A);
    for k=1:length(d)
        if k <= a
            if A(k).bytes ~= d(k).bytes
                A(k).name = d(k).name;
                A(k).date = d(k).date;
                A(k).bytes = d(k).bytes;
                A(k).isdir = d(k).isdir;
                A(k).datenum = d(k).datenum;
                A(k).data = [];
            end
        else
            A(k).name = d(k).name;
            A(k).date = d(k).date;
            A(k).bytes = d(k).bytes;
            A(k).isdir = d(k).isdir;
            A(k).datenum = d(k).datenum;
        end
    end
end
N=length(A);
% display(N);
w = waitbar(0,'','Name',['Load ' DirName '\' FileMask]);
set(get(get(w,'Children'),'Title'),'Interpreter','none')
% matlabpool(8);
% O(length(A)).data=[];
% O(length(A)).start=[];
% O(length(A)).rate=[];
% O(length(A)).size=[];
% O(length(A)).head=[];
for fid=1:length(A)
    w = waitbar((fid-1)/N,w,A(fid).name);
    if ~isfield(A(fid),'data') || isempty(A(fid).data)
        O = LoadFile([DirName '\' A(fid).name]);
        A(fid).data = O.data;
        A(fid).start = O.start;
        A(fid).rate = O.rate;
        A(fid).size = O.size;
        A(fid).head = O.head;
        O=[];
    end
    waitbar(fid/N,w);
end
% A=B;
clear O B DirName2
waitbar(0,w,'Saving...','Name',s);
close(w);
% save(s, 'A');
w=waitbar(0,'','Name','Обработка данных');
for k=1:length(A)
    OscillAnalize(k)
    waitbar(k/length(A),w,k);
end
close(w);
save(s, 'A');
end