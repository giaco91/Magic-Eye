    function R = SIPS(T,P,r)
    %T, die Topografie des darzustellenden 3D-Bildes
    %r, die stärke der Tiefenwirkung [0,10], darüber wird es hässlich
    r=r/30;
    N = size(T);
    NP= size(P);
    %T wird mit Nullvektor erweitert bis fünfteiligkeit
    T = [T zeros(N(1),5-mod(N(2),5))];
    N(2)= N(2)+5-mod(N(2),5);
    b = N(2)/5;
    if b>NP(2)
        B = rand(N(1),b,3);
    else       
        mid2=floor(NP(2)/2);
        mid1=floor(NP(1)/2);
        if NP(1)>N(1)
            B = P(mid1-floor(N(1)/2):mid1+ceil(N(1)/2),mid2-floor(b/2):mid2+ceil(b/2),:);
        else
            rep=ceil(N(1)/NP(2));
            B = repmat(P(:,mid2-floor(b/2):mid2+ceil(b/2),:),rep,1,1);
            B=B(1:N(1),:,:);
        end
    end

    
    % Das Bild braucht auf der linken Seiten einen Streifen mehr als die Topografie
    B = [B B B B B B];
        
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
    
    %um gleiche Dimensionen zu schaffen zwischen T und B; linkseitig einen
    %Nullstreifen einfüren
    T = [zeros(N(1),b) T];
    
    %3-D Effekt: Die Verschiebung der Pixel
    %Wir arbeiten von oben nach unten
    for i = 1:N(1);
        %und von links nach rechts (Parallel-Blick)
        for j = b:6*b;
            %verschiebt den Punkt nach links um den Betrag der Topografie
            B(i,j-T(i,j),:)=B(i,j,:);
            for l = 1:div(6*b-(j-T(i,j)),b)
                %und überträgt diesen auf alle anderen folgenden Streifen
                B(i,j-T(i,j)+b*l,:)=B(i,j,:); 
            end
            %Erstellung des für das eine Auge verdeckten Bildes
            if T(i,j)<T(i,j-1)
                h=T(i,j-1)-T(i,j);
                %führt den Schatten links ein um den Betrag des Abstiegs h
                for k = 1:h;
                    r=1;
                    %r=round(rand(1));
                    B(i,j-k,:) = r*B(i,j-(k-1),:)+(1-r)*B(i-1,j-k,:);
                    %B(i,j-k,:) = round(255*rand(1,1,3));
                    %und überträgt diesen auf alle anderen
                    %folgenden Streifen
                    for l = 1:div(6*b-(j-k),b)
                        B(i,j-k+b*l,:)=B(i,j-k,:); 
                    end
                end
            end
        end
    end
    
    %zeige Bild
    Bg=togray(B);
    Bc=color_map(Bg);
    r=0.5;
    B=r*Bc+(1-r)*double(B)/256;
    imshow(B);
    R=B;
   
    end
    
    %Wie oft eine a durch b teilbar ist ohne rest
    function m = div(a,b)
        m = (a-mod(a,b))/b;
    end

        