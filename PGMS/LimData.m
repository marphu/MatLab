function LimData( varargin )
global u a
Ch = get(a(1).aid,'Children');
Xl = [0 0];
Yl = [0 0];
for k = 1:length(Ch);
    Xl(1) = min(Xl(1),min(get(Ch(k),'XData')));
    Xl(2) = max(Xl(2),max(get(Ch(k),'XData')));
    Yl(1) = min(Yl(1),min(get(Ch(k),'YData')));
    Yl(2) = max(Yl(2),max(get(Ch(k),'YData')));
end
Xs = diff(Xl);
% Xl(1)=0;
Ys = diff(Yl);
Yl = Yl + Ys * [-1 +1] / 40;
Ys = diff(Yl);
if length(u) < 4
    return;
end
xmin = get(u(4).uid,'Value');
xmax = get(u(5).uid,'Value');
if xmax <= xmin
    if varargin{1} == u(4).uid
        xmin = xmax - 0.01;
        set(u(4).uid,'Value',xmin)
    elseif varargin{1} == u(5).uid
        xmax = xmin + 0.01;
        set(u(5).uid,'Value',xmax)
    end
end
ymin = get(u(6).uid,'Value');
ymax = get(u(7).uid,'Value');
if ymax <= ymin
    if varargin{1} == u(6).uid
        ymin = ymax - 0.01;
        set(u(6).uid,'Value',ymin)
    elseif varargin{1} == u(7).uid
        ymax = ymin + 0.01;
        set(u(7).uid,'Value',ymax)
    end
end
Xv=Xl(1)+[xmin xmax]*Xs;
Yv=Yl(1)+[ymin ymax]*Ys;
set(u(8).uid,'String',Xv(1));
set(u(9).uid,'String',Xv(2));
set(u(10).uid,'String',Yv(1));
set(u(11).uid,'String',Yv(2));
xlim(a(1).aid,Xv);
ylim(a(1).aid,Yv);
end