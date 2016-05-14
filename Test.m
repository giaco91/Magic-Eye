clear, clc, close all
addpath('Magic_topografie','Magic_background');

%Topografie
T_colored=imread('pingu.jpg');
T=togray(T_colored);

%Invertierung
T=T*(-1)+1;

%runde auf Zwei-Level-Topografie
T=round(T);

%Background
B=imread('PinguLand.jpg');

%Erzeuge Magic-Eye Bild
SIPS(T,B,4,0.8);



