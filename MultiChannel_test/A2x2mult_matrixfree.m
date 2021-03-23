function [ res ] = A2x2mult_matrixfree( c11,c12,c21,c22, x,ang,N )
%function [ res ] = A2x2mult_matrixfree( c11,c12,c21,c22,g,ang,N )
% This function calculates operation with radon function, which corresponds 
% multiplication A*g for system with two images and two materials.
%
% Version 1.0, September 20, 2019
% (c) Salla Latva-�ij� and Samuli Siltanen 
%
% Routine for the two-energies and two materials scheme related to S Siltanen's 
% method for solution of the conjugate gradient Tikhonov algorithm.
% Computes corresponding calculation A*g but without matrix A.
% 
% Arguments
% c11       attenuation coefficient for material one imaged with energy E1(low)
% c12       attenuation coefficient for material two imaged with energy E1(low)
% c21       attenuation coefficient for material one imaged with energy E2(high)
% c22       attenuation coefficient for material two imaged with energy E2(high)
% g        reconstruction image of target 1
% ang      measurement angles
% N        NxN is the size of the image g1 and g2 
% Returns
% res       sinograms of g, as images one after another (size x*40) 
%
% Last revision Salla Latva-�ij� Sep 2019

% This function calculates multiplication A*g for system with two images
% and two materials, without constructing the matrix A.

%First separate the parts of g:
g1=reshape(x(1:(end/2),:),N,N);
g2=reshape(x((end/2+1):end,:),N,N);


% Perform the needed matrix multiplications. Now a matrix multiplication
% has been switched to radon
ag1 = radon(g1,ang);
ag2 = radon(g2,ang);

% Calculate the parts needed for block matrix multiplication
res1 = c11*ag1(:);
res2 = c12*ag2(:);
res3 = c21*ag1(:);
res4 = c22*ag2(:);

% Combine results into the result
res = [res1 + res2; res3 + res4];
end