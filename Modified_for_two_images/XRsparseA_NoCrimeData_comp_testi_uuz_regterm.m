% Example computations related to X-ray tomography.
% HERE I TRY TO MAKE THIS WORK FOR TWO IMAGE SYSTEM

% Here we use the Barzilai and Borwain optimization method 
% to find the minimum of the regularized penalty functional
%
%		1/2 (Af - m)^T (Af - m) + alpha*sum(sqrt((f_i-f_j)^2+beta))
%
% with the sum ranging over i and j indexing all horizontally 
% and vertically neighboring pixel pairs.
%
% The approximation results from the positive constant beta rounding the 
% non-differentiable corner of the absolute value function. This way the 
% penalty functional becomes differentiable and thus efficiently optimizable.
%
%
% Jennifer Mueller and Samuli Siltanen, March 2014
%Modified by Salla 2.7.2020
clear all;
% Regularization parameter
alpha = 500;

% Maximum number of iterations. You can modify this value and observe the
% effects on the reconstruction.
MAXITER = 5000;               
% Choose the angles for tomographic projections
Nang       = 65; % odd number is preferred
ang        = [0:(Nang-1)]*360/Nang;
% Smoothing parameter used in the approximate absolute value function
beta    = .000001; 
M = 128;
target1 = imresize((imread('new_HY_material_one_bmp.bmp')), [M M]);
target2 = imresize((imread('new_HY_material_two_bmp.bmp')), [M M]);
target1=double(target1(:,:,1));
target2=double(target2(:,:,1));
%%
% Vektorize
g1 = target1(:);
g2 = target2(:);
% Combine
x  =[g1;g2];
N = size(x,1);

%Coefficient without multiplication with density
% c11    = 1.7237;%PVC 30kV
% c12    = 37.57646; %Iodine 30kV
% c21    = 0.3686532;%PVC 50kV 
% c22    = 32.404; %Iodine 50kV

% Coefficients multiplied with density!!!
% Define attenuation coefficients: Iodine and PVC
%  material1='Iodine';
%  material2='PVC';
% c11    = 42.2057; %Iodine 30kV
% c21    = 60.7376; %Iodine 50kV
% c12    = 2.096346;%PVC 30kV
% c22    = 0.640995;%PVC 50kV

c11     = 1.491; % PVC    30kV  (Low energy)
c12     = 8.561; % Iodine 30kV
c21     = 0.456; % PVC    50kV  (High energy)
c22     = 12.32; % Iodine 50kV

% Sinogram
mncn  = A2x2mult_matrixfree(c11,c12,c21,c22,x,ang,M);

% Load noisy measurements from disc. The measurements have been simulated
% (avoiding inverse crime) in routine XRsparse3_NoCrimeData_comp.m
%load XRsparse_NoCrime N mnc mncn measang target

[M,tmp] = size(reshape(x,[M 2*M]));

% Incomprehensible correction factor. It is related to the way Matlab
% normalizes the output of iradon.m. The value is empirically found and
% tested to work to reasonable accuracy. 
corxn = 40.7467*M/64; 
gamma = 2000;
% Optimization routine
obj    = zeros(MAXITER+1,1);     % We will monitor the value of the objective function
fold   = zeros(size(x));    % Initial guess
gold   = XR_aTV_fgrad_modified_regterm(fold,mncn,ang,corxn,alpha,beta,c11,c12,c21,c22,M,N,gamma);
obj(1) = XR_aTV_feval_modified(fold,mncn,ang,alpha,beta,M,c11,c12,c21,c22); 

% Make the first iteration step. Theoretically, this step should satisfy 
% the Wolfe condition, see [J.Nocedal, Acta Numerica 1992]. 
% We use simply a constant choice since it usually works well.
% If there is a problem with convergence, try making t smaller. 
t = .0001;

% Compute new iterate point fnew and gradient gnew at fnew
fnew = max(fold - t*gold,0);
gnew = XR_aTV_fgrad_modified_regterm(fnew,mncn,ang,corxn,alpha,beta,c11,c12,c21,c22,M,N,gamma);     

% Iteration counter
its = 1;    

% Record value of objective function at the new point
OFf        = XR_aTV_feval_modified(fnew,mncn,ang,alpha,beta,M,c11,c12,c21,c22);
obj(its+1) = OFf;

% Initialize gradient (new reg term=graddu)
graddu = zeros(N,1);
graddu = graddu(:);
% Count the second regterm
i1 = 1:N; i2 = [N/2+1:N,1:N/2];
for j = 1:N
    graddu(j) = x(i2(j));
    %graddu(j) = g(i1(j))*g(i2(j))^2;vanha!
end

% Barzilai and Borwein iterative minimization routine 
while (its  < MAXITER) 
    its = its + 1;   
    
    % Store previous value of objective function
    fmin = OFf;    
    
    % Compute steplength alpha
    fdiff   = fnew - fold;
    gdiff   = gnew - gold;
    steplen = (fdiff(:).'*fdiff(:))/(fdiff(:).'*gdiff(:));
    
     % Gradient for g again:
    i1 = 1:N; i2 = [N/2+1:N,1:N/2];
    for j=1:N
        %graddu(j) = g(i1(j))*g(i2(j))^2;
        graddu(j) = x(i2(j));
    end
    graddu = graddu(:);
    
    % Update points, gradients and objective function value
    fold = fnew;
    gold = gnew;
    fnew = max(fnew - steplen*gnew,0);
    gnew = XR_aTV_fgrad_modified_regterm(fnew,mncn,ang,corxn,alpha,beta,c11,c12,c21,c22,M,N,gamma);
    OFf  = XR_aTV_feval_modified(fnew,mncn,ang,alpha,beta,M,c11,c12,c21,c22); 
    obj(its+1) = OFf;
    format short e
    % Monitor the run
    disp(['Iteration ', num2str(its,'%4d'),', objective function value ',num2str(obj(its),'%.3e')])
end   % Iteration while-loop
recn = fnew;
% Here we need to separate the different images by naming them as follows:
recn1=reshape(recn(1:(N/2)),M,M);
recn2=reshape(recn(N/2+1:N),M,M);

% Save result to file
save XRsparse_aTV recn1 recn2 alpha target1 target2 obj

% Show pictures of the results
XRsparseD_aTV_plot_modified

%% Compute the error
%RMSE = sqrt(mean((y - yhat).^2));  % Root Mean Squared Error
% Target 1
err_CG1    = norm(target1(:)-recn1(:))/norm(target1(:)); % Square error
SSIM1      = ssim(recn1,target1); % Structural similarity index
RMSE1 = sqrt(mean((target1(:) - recn1(:)).^2));  % Root Mean Squared Error
% Target 2
err_CG2    = norm(target2(:)-recn2(:))/norm(target2(:)); % Square error
SSIM2      = ssim(recn2,target2); % Structural similarity index
RMSE2 = sqrt(mean((target2(:) - recn2(:)).^2));  % Root Mean Squared Error

%HaarPSI index:Ei toimi ennenkuin arvot on normalisoitu?
Haarpsi1=HaarPSI(recn1,target1); 
Haarpsi2=HaarPSI(recn2,target2); 