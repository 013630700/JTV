%MODIFIED FOR TWO IMAGE SYSTEM 
%Routine for tomography. This procedure evaluates the gradient 
%
%      (grad f)(x) = A^T A x - A^T m 
%
% of the quadratic form f(x) = 1/2 (Ax - m)^T (Ax - m).
%
% Arguments:
% x         Evaluation point (image of size NxN)
% m         Measured data (from two images)
% measang   Measurement angles
% corxn     Correction factor needed for using iradon.m to compute adjoints
%
% Returns:
% grad 		gradient of the discrepancy function at point x
%
% Samuli Siltanen February 2011

function grad = XR_misfit_grad_modified(x,m,ang,corxn,c11,c12,c21,c22,N)

% Ax   = radon(x,measang);
% ATAx = iradon(Ax,measang,'none');
% ATAx = ATAx(2:end-1,2:end-1);
% ATAx = corxn*ATAx;

% This function calculates operation with radon function, which corresponds 
% multiplication A*g for system with two images and two materials.

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
% Ax = [res1 + res2; res3 + res4];
% figure(80)
% imshow(Ax,[])
m1 = res1+res2;
m2 = res3+res4;

% m1 = Ax(1:(end/2));
% m1 = reshape(m1, [length(m)/(2*length(ang)) length(ang)]);
% m2 = Ax((end/2+1):end);
% m2 = reshape(m2, [length(m)/(2*length(ang)) length(ang)]);

corxn = 7.65; % Incomprehensible correction factor

% Perform the needed matrix multiplications. Now a.' multiplication has been
% switched to iradon
am1 = iradon(m1,ang,'none');
am1 = am1(2:end-1,2:end-1);
am1 = corxn*am1;

am2 = iradon(m2,ang,'none');
am2 = am2(2:end-1,2:end-1);
am2 = corxn*am2;

% Compute the parts of the result individually
res1 = c11*am1(:);
res2 = c21*am2(:);
res3 = c12*am1(:);
res4 = c22*am2(:);

% Collect the results together
ATAx = [res1 + res2; res3 + res4];




% ATm = iradon(m,measang,'none');
% ATm = ATm(2:end-1,2:end-1);
% ATm = corxn*ATm;

m1 = m(1:(end/2));
m1 = reshape(m1, [length(m)/(2*length(ang)) length(ang)]);
m2 = m((end/2+1):end);
m2 = reshape(m2, [length(m)/(2*length(ang)) length(ang)]);

corxn = 7.65; % Incomprehensible correction factor

% Perform the needed matrix multiplications. Now a.' multiplication has been
% switched to iradon
am1 = iradon(m1,ang,'none');
am1 = am1(2:end-1,2:end-1);
am1 = corxn*am1;

am2 = iradon(m2,ang,'none');
am2 = am2(2:end-1,2:end-1);
am2 = corxn*am2;

% Compute the parts of the result individually
res1 = c11*am1(:);
res2 = c21*am2(:);
res3 = c12*am1(:);
res4 = c22*am2(:);

% Collect the results together
ATm = [res1 + res2; res3 + res4];
grad  = ATAx - ATm;