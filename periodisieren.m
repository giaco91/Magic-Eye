function Bp=periodisieren(B,k,b)
%periodisiere das Bild B durch Überlappung
%k-der prozentuale Anteil der pro Seite periodisiert wird
%b-die Breite des periodisierten Bildes

%konvertiere die Elemente von B auf jeden Fall in double-Werte
B=double(B)/256;

%linker und rechter Überlappungsbereich
left=floor(k*b);
right=ceil(k*b);

Bp=B(:,left+1:end-right,:);

f=1/(left+right+1);
        for i=1:right
            s=f*(i+left);
            Bp(:,i,:)=s*B(:,i+left,:)+(1-s)*B(:,end-right+i,:);
        end
        for i=1:left
            s=f*(i+right);
            Bp(:,end-(i-1),:)=s*B(:,end-(i-1)-right,:)+(1-s)*B(:,left-i+1,:);
        end
Bp=Bp*256;

end

