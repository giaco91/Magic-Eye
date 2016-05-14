    function R = SIPS(T,P,r,col)
    %T, die Topografie des darzustellenden 3D-Bildes
    %P, das Hintergrundbild
    %r, die stärke der Tiefenwirkung [0,10], darüber wird es hässlich
    %col, der colorierungsfaktor (zwischen 0 und 1)
    r=r/30;
    N = size(T);
    NP= size(P);
    %T wird mit Nullvektor erweitert bis fünfteiligkeit
    t=4;%Anzahl verschiebende Streifen
    T = [T zeros(N(1),t-mod(N(2),t))];
    N(2)= N(2)+t-mod(N(2),t);
    b = N(2)/t;
    k=0.2; %Der Periodisierungsfaktor
    if b+2*k*b>NP(2)
        B = rand(N(1),b,3);
    else 
        mid2=floor(NP(2)/2);
        mid1=floor(NP(1)/2);
        if NP(1)>N(1)
            B = P(mid1-floor(N(1)/2):mid1+ceil(N(1)/2),mid2-floor(b/2)-floor(k*b):mid2+floor(b/2)+ceil(k*b),:);
        else
            rep=ceil(N(1)/NP(1));
            B = repmat(P(:,mid2-floor(b/2)-floor(k*b):mid2+floor(b/2)+ceil(k*b),:),rep,1,1);         
            B=B(1:N(1),:,:);
        end
        B=periodisieren(B,k,b);
    end
   
    % ein Buffer-Streifen auf der linken Seite
    B = repmat(B,1,t+1);
    T = [zeros(N(1),b) T];
       
    %Bias, sodass T eine positive Matrix wird
    Min = min(min(T));
    if Min<0
        T=T-Min;
    end
    
    %normiere T, sodass jetzt 0<=T.<=1
    Max = max(max(T));
    if Max>0
        T = (T/Max);
    end
    
    %Tiefenwirkung wird mit r bezüglich der Basisstreifenlänge (abh. vom
    %Input-Bild) skaliert
    T = round(T*b*r);
     
    %3-D Effekt: Die Verschiebung der Pixel
    %Wir arbeiten von oben nach unten...
    for i = 2:N(1);
        %...und von links nach rechts (Parallel-Blick)
        for j = b:(t+1)*b;
            %verschiebt den Punkt nach links um den Betrag der Topografie
            B(i,j-T(i,j),:)=B(i,j,:);
            for l = 1:div((t+1)*b-(j-T(i,j)),b)
                %und überträgt diesen auf alle anderen folgenden Streifen
                B(i,j-T(i,j)+b*l,:)=B(i,j,:); 
            end
            %Erstellung des für das linke Auge verdeckten Bildes
            if T(i,j)<T(i,j-1)
                h=T(i,j-1)-T(i,j);
                %führt den Schatten links ein um den Betrag des Abstiegs h
                for k = 1:h;
                    r=[0.9 0.09 0.01];
                    B(i,j-k,:) = r(1)*double(B(i,j-(k-1),:))+r(2)*double(B(i-1,j-k,:))+r(3)*round(255*rand(1,1,3));
                    %und überträgt diesen auf alle anderen
                    %folgenden Streifen
                    for l = 1:div((t+1)*b-(j-k),b)
                        B(i,j-k+b*l,:)=B(i,j-k,:); 
                    end
                end
            end
        end
    end
    
    %coloriere Bild
    Bc=magic_color(B);
    
    %überlagere ein Teil des originalbildes
    B=col*Bc+(1-col)*double(B)/256;
    
    %zeige Bild
    imshow(B)
    R=B;
   
end
    
    %Wie oft eine a durch b teilbar ist ohne rest
    function m = div(a,b)
        m = (a-mod(a,b))/b;
    end

            