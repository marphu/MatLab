plot(A(2).data(:,1),A(2).data(:,2))
hold on
plot(A(2).T5+A(2).StartPoint,A(2).I5,'or')
for k=1:6
    text(A(2).T5(k)+A(2).StartPoint/3,A(2).I5(k),...
        sprintf('%d',k));
end