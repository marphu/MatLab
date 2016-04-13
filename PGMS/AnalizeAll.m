loadf = true; %#ok;
loadf = false; %;
if loadf
    clear B %#ok;
    B=[];
    w=dir('*.pgc');
    for k=1:length(w)
        load([w(k).name(1:end-4) '/test_.txt.mat']);
        display(sprintf('%d',k));
        for n=1:length(A)
            A(n).N=n;
            A(n).s=k;
            A(n).Z=[k n];
        end
        B=[B;A];
    end
end
clear Z X
z=[0 0 0 0];
gr=50e-3;
for k=1:length(B)
    B(k).data=[]; %#ok;
    if B(k).type(1) == 1
        z(1) = z(1) + 1;
        X{1,z(1)} = z(1); %#ok;
        if B(k).BK > gr
            Z{1,z(1)} = gr/1.1;%#ok;
        else
            Z{1,z(1)} = B(k).BK;%#ok;
        end
    elseif B(k).type(1) == 2
        z(2) = z(2) + 1;
        if B(k).StartPoint > 0
            z(3) = z(3) + 1;
            X{2,z(3)} = z(2);%#ok;
            Z{2,z(3)} = B(k).BK;%#ok;
        else
            z(4) = z(4) + 1;
            X{3,z(4)} = z(2);%#ok;
            Z{4,z(2)} = B(k).Raz3;%#ok;
            if B(k).BK > gr
                Z{3,z(2)} = gr;%#ok;
            else
                Z{3,z(2)} = B(k).BK;%#ok;
            end
        end
    end
end
subplot(2,2,1)
hold off
plot([X{1,:}],[Z{1,:}]*1000,'r*','MarkerSize',1.5)
hold on
plot([X{2,:}],[Z{2,:}]*1000,'g*','MarkerSize',2)
plot([X{3,:}],[Z{3,:}]*1000,'b*','MarkerSize',2)
plot([X{1,1:100:end}],...
    1000*polyval(polyfit([X{1,:}],[Z{1,:}],1),[X{1,1:100:end}]),...
    'c','LineWidth',2)
plot([X{2,1:100:end}],...
    1000*polyval(polyfit([X{2,:}],[Z{2,:}],1),[X{2,1:100:end}]),...
    'm','LineWidth',2)
hold off
grid on
legend({'Включение','Отключение','Размагничивание'},...
    'location','NorthWest','Orientation','Horizontal')
n=0;
o=[1 8];
f=[2 7 13];
s=[3 4 5 6 9 11 12 14 15];
clear I5 T5 Razm
z=0;
Z1=[];
Z2=[];
Z3=[];
Z4=[];
r=0;
for k=1:length(B)
    if B(k).type(1) == 1
        if ~isempty(B(k).R)
            z=z+1;
            Z1(z) = B(k).R; %#ok;
            if r == 1
                Z3(z) = Z1(z); %#ok
                Z4(z) = NaN; %#ok
                r=0;
            else
                Z4(z) = Z1(z); %#ok
                Z3(z) = NaN; %#ok
            end            
        else
            Z2(z) = NaN; %#ok;
        end
        Z2(z) = NaN; %#ok;
    end
    if B(k).type(1) == 2
        if ~isempty(B(k).Raz3)
            Z2(z) = B(k).Raz3;%#ok;
            r=1;
        end
    end
    if ~isempty(B(k).Razm)
        if max(B(k).s==s)
            n=n+1;
            Razm(n) = B(k).Razm;%#ok;
            d=2;
            while isempty(B(k-d).I5)
                d=d+1;
            end
            for l=1:6
                I5(l,n) = B(k-d).I5(l);%#ok;
                T5(l,n) = B(k-d).T5(l);%#ok;
                R2(n) = B(k-d).R;%#ok;
            end
            t=B(k).s;
        end
    end
end
Z2(z)=NaN;
Z3(z)=NaN;
subplot(2,2,2)
Yr=Razm;

Xr = Prq(1)*(T5(5,:) - T5(4,:)).*(I5(4,:) + I5(5,:)) + ...
    Prq(2)*(T5(6,:) - T5(5,:)).*(I5(6,:) + I5(5,:));
% Xr = (T5(6,:) - T5(4,:)).*(I5(4,:) + I5(5,:) + I5(6,:));
hold off
% plot(Xr,Yr,'.')
plot(Xr,Razm,'.')
hold on
p = polyfit(Xr,Yr,1);
display(p);
% p= [-3.95 1.35];
plot([min(Xr) max(Xr)],polyval(p,[min(Xr) max(Xr)]),'r-')
dY2=(Yr-polyval(p,Xr)).^2;
% sqrt(sum(dY2)/length(dY2));
subplot(2,2,3)
Razm2 = polyval(p,Xr);
plot(Razm,'r.')
hold on
plot(Razm2,'g.')
hold off
legend({'Mesured','Calculated'})
subplot(2,2,4)
hold off
plot(Z4,'r.')
hold on
plot(Z2,'g.')
plot(Z3,'b.')
hold off
legend({'Рассчетный','Измеренный','После размагничивания'},...
    'location','SouthOutside','Orientation','Horizontal')
grid on
Interval=1;
while sum(abs(Razm-Razm2)*1000<Interval)/length(Razm)<0.85
    Interval=Interval+.1;
end
title(sprintf('\\pm%2.1f', Interval))