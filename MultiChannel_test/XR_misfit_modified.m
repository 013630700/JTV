% This procedure evaluates the quadratic form 
%
%      f(x) = 1/2 (Ax - m)^T (Ax - m).
%
% Arguments:
% x         Evaluation point (image of size NxN)
% m         Measured data
% measang   Measurement angles
%
% Returns:
% result 		value of the discrepancy function at point x
%
% Samuli Siltanen February 2011

function result = XR_misfit_modified(x,m,ang,N,c11,c12,c21,c22)

%Original: Ax_m = radon(x,measang)-m;
% Wanted: A2x2mult_matrixfree(c11,c12,c21,c22,target,ang,M)-mncn;

% This function calculates multiplication A*g for system with two images
% and two materials, without constructing the matrix A.
% Erotellaan vektorista x kaksi osaa: g1 ja g2.
g1=reshape(x(1:(end/2),:),N,N);
g2=reshape(x((end/2+1):end,:),N,N);

% Perform the needed matrix multiplications. Now a matrix multiplication
% has been switched to radon
ag1 = radon(g1,ang);
ag2 = radon(g2,ang);

% Calculate the parts needed for block matrix multiplication
res1 = c11*ag1;
res2 = c12*ag2;
res3 = c21*ag1;
res4 = c22*ag2;

% Combine results into the result
Ax = [res1 + res2; res3 + res4];

Ax_m =Ax-m;
result = Ax_m(:).'*Ax_m(:);