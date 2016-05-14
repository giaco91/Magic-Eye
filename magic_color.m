function C = magic_color(R)
%konvertiere R in ein Graustufenbild
R=togray(R);

%Superposition zweier harmonischen Methoden verschiedener Ordnung
r=0.7;
C=(r*HarmonMet(R,3)+(1-r)*HarmonMet(R,10));

end

%Lineare Methode: Kontrast in einer Random-Farbe
function C=LinMet(R,d)
    w=[1/d;1;d];
    select=randperm(3,3);
    w=[w(select(1)); w(select(2)); w(select(3))];
    C=cat(3,w(1)*R,w(2)*R,w(3)*R);
end

%Polynomiale Methode:
function C=PolyMet(R,d)
    p=[1/d;1;d];
    select=randperm(3,3);
    p=[p(select(1)); p(select(2)); p(select(3))];
    C=cat(3,R.^p(1),R.^p(2),R.^p(3));
end

%Harmonische Methode
function C=HarmonMet(R,d)
    f=[d;d^(3/2);d^2];
    select1=randperm(3,3);
    f=[f(select1(1)); f(select1(2)); f(select1(3))];
    phi=2*pi*rand(3,1);
    C=cat(3,1/2*(1+sin(2*pi*f(1)*R+phi(1))),...
        1/2*(1+sin(2*pi*f(2)*R+phi(2))),1/2*(1+sin(2*pi*f(3)*R+phi(3))));

end