function p=OptimizeRazm(Razm,I5,T5,M)
s=size(M);
X=zeros(size(Razm));
for k=1:length(Razm)
    X(k) = 0;
    for m=1:s(1)
        for n=1:s(2)
            X(k)=X(k)+I5(n,k)*T5(m,k)*M(m,n);
        end
    end
end
po=polyfit(X,Razm,1);
R = abs(Razm-polyval(po,X));
p=sum(R<0.010)/length(Razm);