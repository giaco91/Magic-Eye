%Topographie
T_colored=imread('HERZ.jpg');
T=togray(T_colored);

%Background
B=imread('MaPa.jpg');

%Erzeuge Magic-Eye Bild
SIPS(T,B,3.5);