% Example computations related to X-ray tomography.
% HERE I TRY TO MAKE THIS WORK FOR MC TWO IMAGE SYSTEM

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
alpha = 1000;

% Maximum number of iterations. You can modify this value and observe the
% effects on the reconstruction.
MAXITER = 20000;               
% Choose the angles for tomographic projections
Nang       = 65; % odd number is preferred
ang        = [0:(Nang-1)]*360/Nang;
rotang     = 45;
% Smoothing parameter used in the approximate absolute value function
beta    = .0001; 
N = 128;
noiselevel = 0.01;

% Texture phantom 2
target1 = imread('phantom_maya1.bmp');
target2 = imread('phantom_maya2.bmp');

% Texture phantom 1
% target1 = imread('phantom_carpet1.bmp');
% target2 = imread('phantom_carpet2.bmp');

% HY phantom
% target1 = imread('phantom_hy1.bmp');
% target2 = imread('phantom_hy2.bmp');

% Bone phantom
% target1 = imread('phantom_bone1.bmp');
% target2 = imread('phantom_bone2.bmp');

% Select one of the channels
target1 = target1(:,:,1);
target2 = target2(:,:,1);

figure(89)
imshow(target1,[]);
figure(99)
imshow(target2,[]);
% Change to double
target1=double(target1);
target2=double(target2);

% Resize the image
target1      = imresize(target1, [N N], 'nearest');
target2      = imresize(target2, [N N], 'nearest');

% Avoid inverse crime by rotating the object (interpolation)
target1_rot      = imrotate(target1,rotang,'bilinear','crop');
target2_rot      = imrotate(target2,rotang,'bilinear','crop');

%%
% Vektorize
% g1 = target1(:);
% g2 = target2(:);

% Combine the two material images (both 2D images) as one vertical vector
% by vectorizing and stacking the two images on top of each other
x  =[target1_rot(:);target2_rot(:)];

%% Start reconstruction
% % Simulate measurements SINOGRAM
%Coefficient without multiplication with density
% c11    = 1.7237;%PVC 30kV
% c12    = 37.57646; %Iodine 30kV
% c21    = 0.3686532;%PVC 50kV 
% c22    = 32.404; %Iodine 50kV

% Coefficients multiplied with density!!!
%  material1='PVC';
%  material2='Iodine';
% c11    = 2.096346;%PVC 30kV
% c12    = 42.2057; %Iodine 30kV
% c21    = 0.640995;%PVC 50kV
% c22    = 60.7376; %Iodine 50kV

c11     = 1.491; % PVC    30kV  (Low energy)
c12     = 8.561; % Iodine 30kV
c21     = 0.456; % PVC    50kV  (High energy)
c22     = 12.32; % Iodine 50kV
%% Start reconstruction
% Simulate noisy measurements avoiding inverse crime 
m       = A2x2mult_matrixfree_rotang(c11,c12,c21,c22,x,ang,N,rotang); 
% Add noise/poisson noise
mncn  = m + noiselevel*max(abs(m(:)))*randn(size(m));

% Incomprehensible correction factor. It is related to the way Matlab
% normalizes the output of iradon.m. The value is empirically found and
% tested to work to reasonable accuracy. 
corxn = 40.7467*N/64; 

% Optimization routine following Barzilai-Borwein
obj    = zeros(MAXITER+1,1);     % We will monitor the value of the objective function
fold   = zeros(size(x));    % Initial guess
gold   = XR_aTV_fgrad_modified(fold,mncn,ang,corxn,alpha,beta,c11,c12,c21,c22,N);
obj(1) = XR_aTV_feval_modified(fold,mncn,ang,alpha,beta,N,c11,c12,c21,c22); 

% Make the first iteration step. Theoretically, this step should satisfy 
% the Wolfe condition, see [J.Nocedal, Acta Numerica 1992]. 
% We use simply a constant choice since it usually works well.
% If there is a problem with convergence, try making t smaller. 
t = .0001;

% Compute new iterate point fnew and gradient gnew at fnew
%gold = reshape(gold,2*N,N);
fnew = max(fold - t*gold,0);
gnew = XR_aTV_fgrad_modified(fnew,mncn,ang,corxn,alpha,beta,c11,c12,c21,c22,N);     

% Iteration counter
its = 1;    

% Record value of objective function at the new point
OFf        = XR_aTV_feval_modified(fnew,mncn,ang,alpha,beta,N,c11,c12,c21,c22);
obj(its+1) = OFf;

% Barzilai and Borwein iterative minimization routine 
%figure(33)
while (its  < MAXITER) 
    its = its + 1;   
    
    % Store previous value of objective function
    fmin = OFf;    
    
    % Compute steplength alpha
    fdiff   = fnew - fold;
    gdiff   = gnew - gold;
    steplen = (fdiff(:).'*fdiff(:))/(fdiff(:).'*gdiff(:));
    
    % Update points, gradients and objective function value
    fold = fnew;
    gold = gnew;
    fnew = max(fnew - steplen*gnew,0);
    gnew = XR_aTV_fgrad_modified(fnew,mncn,ang,corxn,alpha,beta,c11,c12,c21,c22,N);    
    OFf  = XR_aTV_feval_modified(fnew,mncn,ang,alpha,beta,N,c11,c12,c21,c22); 
    obj(its+1) = OFf;
    format short e
    %imshow(fnew,[])
    % Monitor the run
    if mod(its,100)==0
        disp(['Iteration ', num2str(its),', objective function value ',num2str(obj(its),'%.8e')])
    end
end   % Iteration while-loop
%%
recn = fnew;
% Here we need to separate the different images by naming them as follows:
% Erotellaan vektorista x kaksi osaa: g1 ja g2.
recn1=reshape(recn(1:(end/2),:),N,N);
recn2=reshape(recn((end/2+1):end,:),N,N);


% Save result to file
save XRsparse_aTV_JTV_maya recn1 recn2 alpha target1 target2 obj
%% Calculate the error
% Target 1
E1    = norm(target1(:)-recn1(:))/norm(target1(:)); % Square error
SSIM1      = ssim(recn1,target1); % Structural similarity index
RMSE1      = sqrt(mean((target1(:) - recn1(:)).^2));  % Root Mean Squared Error
% Target 2
E2    = norm(target2(:)-recn2(:))/norm(target2(:)); % Square error
SSIM2      = ssim(recn2,target2); % Structural similarity index
RMSE2      = sqrt(mean((target2(:) - recn2(:)).^2));  % Root Mean Squared Error
% Total errors calculated as mean of the errors of both reconstructions
E_mean       = sqrt(E1*E2);
SSIM        = (SSIM1+SSIM2)/2;
RMSE        = (RMSE1 + RMSE2)/2;
%% Show pictures of the results
XRsparseD_aTV_plot_modified_texture

%% Save image
% Samu's version for saving:
% normalize the values of the images between 0 and 1
im1=target1;     % material 1: PVC
im2=target2;     % material 2: Iodine
im3=recn1;   % reconstruction of PVC
im4=recn2;   % reconstruction of Iodine

MIN = min([min(im1(:)),min(im2(:)),min(im3(:)),min(im4(:))]);
MAX = max([max(im1(:)),max(im2(:)),max(im3(:)),max(im4(:))]);
im1 = im1-MIN;
im1 = im1/(MAX-MIN);
im2 = im2-MIN;
im2 = im2/(MAX-MIN);
im3 = im3-MIN;
im3 = im3/(MAX-MIN);
im4 = im4-MIN;
im4 = im4/(MAX-MIN);
imwrite(uint8(255*im3),'JTV_reco1_tex.png')
imwrite(uint8(255*im4),'JTV_reco2_tex.png')

%HaarPSI index:
%HaarPSI index:Ei toimi ennenkuin arvot on normalisoitu?
Haarpsi1=HaarPSI(255*im1,255*im3); 
Haarpsi2=HaarPSI(255*im2,255*im4);
Haarpsi  = (Haarpsi1+Haarpsi2)/2;

save JTV_maya_for_segmentations im1 im2 im3 im4 N
%% Take a look at the results
figure(4);
% Original phantom1
subplot(2,2,1);
imagesc(target1);
colormap gray;
axis square;
axis off;
title({'Phantom1, matrixfree'});
% Reconstruction of phantom1
subplot(2,2,2)
imagesc(recn1);
colormap gray;
axis square;
axis off;
title(['Approximate error ', num2str(round(E1*100,1)), '%, \alpha=', num2str(alpha), ', \beta=', num2str(beta)]);
% Original target2
subplot(2,2,3)
imagesc(target2);
colormap gray;
axis square;
axis off;
title({'Phantom2, matrixfree'});
% Reconstruction of target2
subplot(2,2,4)
imagesc(recn2);
%imagesc(imrotate(CG2,-45,'bilinear','crop'));
colormap gray;
axis square;
axis off;
title(['Approximate error ' num2str(round(E2*100,1)),'%']);

%% Print the error

fprintf('Error calculations for JTV approach: \n');
fprintf('E1 %.2f     RMSE1 %.2f      SSIM1 %.2f     haarPSI1 %.2f  alpha %.2f \n', E1,RMSE1,SSIM1,Haarpsi1,alpha)
fprintf('E2 %.2f     RMSE2 %.2f      SSIM2 %.2f     haarPSI2 %.2f  alpha %.2f \n', E2,RMSE2,SSIM2,Haarpsi2,alpha)
fprintf('\n');
fprintf('Mean error calculations for JTV approach: \n');
fprintf('E_mean %.2f     RMSE %.2f      SSIM %.2f     haarPSI %.2f  alpha %.2f \n', E_mean,RMSE,SSIM,Haarpsi,alpha)% % Save to disk
% originalImage = recn1;
% outputBaseFileName = 'TV_Reco1.PNG';
% imwrite(originalImage, outputBaseFileName);
% originalImage = recn2;
% outputBaseFileName = 'TV_Reco2.PNG';
% imwrite(originalImage, outputBaseFileName);