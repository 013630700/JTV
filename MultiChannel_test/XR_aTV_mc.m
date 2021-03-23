% Evaluates total variation penalty NOW FOR TWO ENERGIES
%
%	pr(x) = sum{sqrt((x_i-x_j)^2+beta}
%
% with i and j indexing all horizontally and vertically neighboring pixel 
% pairs.
%
% Arguments:
% x			evaluation point of size NxN
% beta 		smoothing parameter (positive)
%
% Samuli Siltanen February 2011

function pr = XR_aTV_mc(x,beta,N)

% Erotellaan vektorista x kaksi osaa: g1 ja g2.
g1=reshape(x(1:(end/2),:),N,N);
g2=reshape(x((end/2+1):end,:),N,N);

% Lasketaan TV kuvalle g1 kutsumalla alkuperäistä funktioita XR_aTV:
g1_TV = XR_aTV(g1,beta);

% Lasketaan TV kuvalle g2 kutsumalla alkuperäistä funktioita XR_aTV:
g2_TV = XR_aTV(g2,beta);

% Lasketaan kokonais TV kahden kuvan systeemille yhdistämällä g1_TV ja
% g2_TV:
TV = g1_TV + g2_TV;

% Jätän tähän vanhan version XR_aTV funktioista, siltä varalta, ettei
% funktiokutsu toisen funktion sisällä toimisikaan toivotusti:
% [row,col] = size(x);
% 
% % Regularization part 1: vertical differences
% Vx = sqrt((x(1:(row-1),:)-x(2:row,:)).^2 + beta);
% 
% % Regularization part 2: horizontal differences
% Hx = sqrt((x(:,1:(col-1))-x(:,2:col)).^2 + beta);
% 
% % Horizontal & vertical contribution
pr = TV;%sum(sum(Vx))+sum(sum(Hx));
