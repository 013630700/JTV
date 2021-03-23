% This procedure evaluates the gradient of the approximate total variation penalty
%
%	aTV(x) = sum{sqrt((x_i-x_j)^2+beta}
%
% with i and j indexing all horizontally and vertically neighboring pixel pairs.
%
% Arguments:
% x   	Evaluation point of size NxN
% beta 	Smoothing parameter for approximate total variation prior
%
% Returns:
% grad	Gradient of approximate TV penalty at x
%
% Samuli Siltanen February 2011

function grad = XR_aTV_grad_mc(x,beta,N)

% Erotellaan vektorista x kaksi osaa: g1 ja g2.
g1=reshape(x(1:(end/2),:),N,N);
g2=reshape(x((end/2+1):end,:),N,N);

% Lasketaan gradientti g1:lle kutsumalla funktioita XR_aTV_grad:
grad_g1 = XR_aTV_grad(g1,beta);

% Lasketaan gradientti g2:lle kutsumalla funktioita XR_aTV_grad:
grad_g2 = XR_aTV_grad(g2,beta);

% Muodostetaan g1:n ja g2:n gradienteista koko tuplakuva systeemin
% gradientti:
grad = [grad_g1(:);grad_g2(:)];


% J�t�n t�h�n v�h�n t�t� funktioita XR_aTV_grad, silt� varalta, ettei
% funktiokutsu toisen sis�ll� toimikaan
% [N,M] = size(x);
% grad  = zeros(N*M,1);
% 
% for n=1:N
%    for m=1:M
%       grad((m-1)*N+n) = 0;
%       if n<N
%          grad((m-1)*N+n) = grad((m-1)*N+n) + ...
%             (x(n,m)-x(n+1,m))/sqrt((x(n,m)-x(n+1,m))^2 + beta);
%       end
%       if n>1
%          grad((m-1)*N+n) = grad((m-1)*N+n) - ...
%             (x(n-1,m)-x(n,m))/sqrt((x(n-1,m)-x(n,m))^2 + beta);
%       end
%       if m<M
%          grad((m-1)*N+n) = grad((m-1)*N+n) + ...
%             (x(n,m)-x(n,m+1))/sqrt((x(n,m)-x(n,m+1))^2 + beta);
%       end
%       if m>1
%          grad((m-1)*N+n) = grad((m-1)*N+n) - ...
%             (x(n,m-1)-x(n,m))/sqrt((x(n,m-1)-x(n,m))^2 + beta);
%       end      
%    end
% end

%grad = grad;%reshape(grad,N,M);