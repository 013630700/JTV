% MODIFIED FOR CALLING FUNCTIONS FOR TWO IMAGES 
%Evaluates objective function
%
% Arguments:
% x         Evaluation point (image of size NxN)
% m         Measured data
% measang   Measurement angles
% alpha     Regularization parameter (positive real constant)
% beta   	Smoothing parameter for approximate total variation prior
%
% Returns:
% f        Value of data_misfit(x) + alpha * aTV_penalty(x)
%
% Samuli Siltanen February 2011

function f = XR_aTV_feval_modified(x,m,measang,alpha,beta,N,c11,c12,c21,c22)

f = XR_misfit_modified(x,m,measang,N,c11,c12,c21,c22) + alpha*XR_aTV_mc(x,beta,N);

