function PlotData( varargin )
global A u a c
global DirName 
u(1).value = get(u(1).uid,'Value');
for fid = u(1).value
    if ~isfield(A(fid),'data') || isempty(A(fid).data)
        O = LoadFile([DirName '\' A(fid).name]);
        A(fid).data = O.data;
        A(fid).start = O.start;
        A(fid).rate = O.rate;
        A(fid).size = O.size;
        A(fid).head = O.head;
        clear O;
    end
end
u(1).String = {A.name};
set(u(1).uid,'String',u(1).String);
u(3).String = {A(u(1).value(1)).head{2:end}}; %#ok;
% display(u(3).String);
set(u(3).uid,'String',u(3).String);
delete(get(a(1).aid,'Children'))
N = get(u(1).uid,'Value');
M = get(u(3).uid,'Value');
if isempty(M)
    M=[1 2 3];
    set(u(3).uid,'Value',M);
end
if length(N) > 4
    N=N(1:4);
    set(u(1).uid,'Value',N);
end
if length(M) > 6
    M=M(1:6);
    set(u(3).uid,'Value',M);
end
color=[
    0.8	0.8	0.0;
    0.0	1.0	0.0;
    1.0 0.0 0.0;
    0.8 0.8 0.5;
    0.5 1.0 0.5;
    1.0 0.5 0.5;
    0.0 0.0 0.0;
    1.0 0.0 1.0];
line={'-' '--' ':' '-.'};
leg = {A(N(1)).head{2:end}}; %#ok;
li=zeros(length(leg)-1,1);
hold all
for n=1:min(length(N),4)
    X = A(N(n)).data(:,1);
    X = X - A(N(n)).StartPoint;
    for m=1:length(M)
        li(M(m))=1;
        if M(m) > 6
            delitelV=100;
        else
            delitelV=1;
        end
        Y = A(N(n)).data(:,M(m)+1)/delitelV;
        if length(c)>=8
            if isfield(c(M(m),2),'uid')
                if get(c(M(m),2).uid,'Value') == 1
                    Y=Ochistk(Y);
                end
            end
            if isfield(c(M(m),1),'uid')
                if get(c(M(m),1).uid,'Value') == 1
                    Y=smooth(Y,20);
                end
            end
        end
        plot(X, Y, line{n}, 'Parent', a(1).aid, 'Color', color(M(m),:));
    end
end
OscillAnalize(N(1));
% if ~isempty(A(N(1)).T5)
%     for k=1:3
%         plot(A(N(1)).T5(k,:),A(N(1)).I5(k,:),'d',...
%             'Color',color(k,:),'MarkerSize',7,'MarkerFaceColor','auto');
%     end
% end
global II
tmp = []; %#ok;
for k=1:3
    if min(size(A(N(1)).Open{k})) >= 1
        Open = A(N(1)).Open{k}+A(N(1)).StartPoint;
        IOpen = zeros(size(Open));
        for p=1:length(IOpen)
            II = A(N(1)).data(:,1) >= Open(p);
            tmp = A(N(1)).data(II,k+1);
            IOpen(p) = tmp(1);
        end
        Open = A(N(1)).Open{k};
        plot(Open,IOpen,'v','Color',color(k,:),'MarkerSize',7,...
            'MarkerFaceColor','auto');
    end
    if min(size(A(N(1)).Close{k})) >= 1
        Close = A(N(1)).Close{k}+A(N(1)).StartPoint;
        IClose = zeros(size(Close));
        for p=1:length(IClose)
            II = A(N(1)).data(:,1) >= Close(p);
            tmp = A(N(1)).data(II,k+1);
            IClose(p) = tmp(1);
        end
        Close = A(N(1)).Close{k};
        plot(Close,IClose,'^','Color',color(k,:),'MarkerSize',7,...
            'MarkerFaceColor','auto');
    end
end
legend(leg(li>0));
hold off
grid on
LimData
end