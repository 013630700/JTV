% Here we calculate the errors for the tresholded images and rekonstruktions.
clear all;
close all;
% First load all images. Original phantoms and reconstructions.
% Maya phantom
load XRsparse_aTV_JTV_Bone recn1 recn2 target1 target2 obj
load JTV_Bone_for_segmentations im1 im2 im3 im4 N
% % figure(1)
% % imshow([target1,target2],[]);
% % figure(2)
% % imshow([recn1,recn2],[]);
% figure(3)
% imshow([target1,target2;recn1,recn2],[]);
% % First treshold the images.
N=128;
% Calculate the right amount of white pixels in the original phantoms.
% First phantom, im1
white_pixels1 = nnz(target1)/(N*N);
% Second phantom
white_pixels2 = nnz(target2)/(N*N);
% Treshold the images so that the amount of white pixels is correct. Here
% the values are between 0 and 1, but they have also other values.

% Calculate the amount of wrong pixels. First we need to decide which
% pixels we set as zero and which will have number 1. We want that kind of
% treshold, which gives us the right amount of white pixels.
% There ratio should be 0.41 in the first reconstruction and 0.25 in the second.
% So in the first reco we want nnz(im3) to be 6717. We get this number of
% white pixels with the following treshold 0.3354.
% MAYA TRESHOLD: 0.3354
% im3_thresholded = im3;
% im3_thresholded(im3>0.0000000000000000000000000000000000000000000000001) = 1;
% im3_thresholded(im3<0.0000000000000000000000000000000000000000000000001) = 0;
% nnz(im3_thresholded)
im3_thresholded = recn1;
im3_thresholded(recn1>0.486)=1;
im3_thresholded(recn1<0.486)=0;
nnz(im3_thresholded)
% We want to treshold the target1 also to be zero or one.
target1_thresholded = target1;
target1_thresholded(target1>1) = 1;
target1_thresholded(target1<1) = 0;
nnz(target1_thresholded)
figure()
imshow([target1_thresholded,im3_thresholded],[])
title('thresholded image im3 = recn1')

% Calculate the error for reconstruction 1
error1=(nnz(target1_thresholded-im3_thresholded))/(N*N);

%% Calculate the error with the second reconstruction
im4_thresholded = recn2;
im4_thresholded(im4>0.25) = 1;
im4_thresholded(im4<0.25) = 0;
nnz(im4_thresholded)

%We want to treshold the target1 also to be zero or one.
target2_thresholded = target2;
target2_thresholded(target2>1) = 1;
target2_thresholded(target2<1) = 0;
nnz(target2_thresholded)
nnz(target2);
figure()
imshow([target2_thresholded,im4_thresholded],[])
title('thresholded image im4 = recn2')

%Calculate the error for reconstruction 1. Caluculate the difference and
%how many pixxels are non-zero.
error2=(nnz(target2_thresholded-im4_thresholded))/(N*N);

figure(5);
% Original phantom1
subplot(2,2,1);
imagesc(target1_thresholded);
colormap gray;
axis square;
axis off;
title({'Bone1 phantom, Ground truth'});
% Reconstruction of phantom2
subplot(2,2,2)
imagesc(im3_thresholded);
colormap gray;
axis square;
axis off;
title(['JTV, Pixel error ', num2str(round(error1,2))]);
% Original target2
subplot(2,2,3)
imagesc(target2_thresholded);
colormap gray;
axis square;
axis off;
title({'Bone2 phantom, Ground truth '});
% Reconstruction of target2
subplot(2,2,4)
imagesc(im4_thresholded);
%imagesc(imrotate(CG2,-45,'bilinear','crop'));
colormap gray;
axis square;
axis off;
title(['JTV, Pixel error ' num2str(round(error2,2))]);

Image = getframe(gcf);
imwrite(Image.cdata, 'segmentations_Bone_JTV.jpg');

%%%%% Color part 
% Material images in color
%
% Samuli Siltanen and Salla Latva-Äijö May 2021

% Material colors
R1 = 241;
G1 = 163;
B1 = 64;
R2 = 153;
G2 = 142;
B2 = 195;


% % % Construct a fake material image. It has 3 color channels: R,G,B and size
% If we do this from two thresholded reconstructions
recon1 = im3_thresholded;
recon2 = im4_thresholded;

ind1 = (recon1>.5);
ind2 = (recon2>.5);

%------------------------------------------
% Initialize color image for two materials
im = zeros(N,N,3);

% Initialize color channels
imR = zeros(N,N);
imG = zeros(N,N);
imB = zeros(N,N);

% Insert material colors into the channels
imR(ind1) = R1;
imR(ind2) = R2;
imG(ind1) = G1;
imG(ind2) = G2;
imB(ind1) = B1;
imB(ind2) = B2;

% Insert the color channels into the color image
im(:,:,1) = imR;
im(:,:,2) = imG;
im(:,:,3) = imB;

%------------------------------------------
% Initialize color image for material 1
im1 = zeros(N,N,3);

% Initialize color channels
imR = zeros(N,N);
imG = zeros(N,N);
imB = zeros(N,N);

% Insert material colors into the channels
imR(ind1) = R1;
imG(ind1) = G1;
imB(ind1) = B1;

% Insert the color channels into the color image
im1(:,:,1) = imR;
im1(:,:,2) = imG;
im1(:,:,3) = imB;

%------------------------------------------
% Initialize color image for  material 2
im2 = zeros(N,N,3);

% Initialize color channels
imR = zeros(N,N);
imG = zeros(N,N);
imB = zeros(N,N);

% Insert material colors into the channels
imR(ind2) = R2;
imG(ind2) = G2;
imB(ind2) = B2;

% Insert the color channels into the color image
im2(:,:,1) = imR;
im2(:,:,2) = imG;
im2(:,:,3) = imB;


%------------------------------------------

% % Show images
% figure(1)
% clf
% subplot(1,3,1)
% imshow(uint8(im))
% title('Both materials')
% subplot(1,3,2)
% imshow(uint8(im1))
% title('Material 1')
% subplot(1,3,3)
% imshow(uint8(im2))
% title('Material 2')


%%%%% Color part 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Material phantoms in color
% Material colors
R1 = 241;
G1 = 163;
B1 = 64;
R2 = 153;
G2 = 142;
B2 = 195;


% % % Construct a phantom image which has 3 color channels: R,G,B and size
phantom1 = target1_thresholded;
phantom2 = target2_thresholded;

ind1 = (phantom1>.5);
ind2 = (phantom2>.5);

%------------------------------------------
% Initialize color image for two materials
pha = zeros(N,N,3);

% Initialize color channels
imR = zeros(N,N);
imG = zeros(N,N);
imB = zeros(N,N);

% Insert material colors into the channels
imR(ind1) = R1;
imR(ind2) = R2;
imG(ind1) = G1;
imG(ind2) = G2;
imB(ind1) = B1;
imB(ind2) = B2;

% Insert the color channels into the color image
pha(:,:,1) = imR;
pha(:,:,2) = imG;
pha(:,:,3) = imB;

%------------------------------------------
% Initialize color image for material 1
pha1 = zeros(N,N,3);

% Initialize color channels
imR = zeros(N,N);
imG = zeros(N,N);
imB = zeros(N,N);

% Insert material colors into the channels
imR(ind1) = R1;
imG(ind1) = G1;
imB(ind1) = B1;

% Insert the color channels into the color image
pha1(:,:,1) = imR;
pha1(:,:,2) = imG;
pha1(:,:,3) = imB;

%------------------------------------------
% Initialize color image for  material 2
pha2 = zeros(N,N,3);

% Initialize color channels
imR = zeros(N,N);
imG = zeros(N,N);
imB = zeros(N,N);

% Insert material colors into the channels
imR(ind2) = R2;
imG(ind2) = G2;
imB(ind2) = B2;

% Insert the color channels into the color image
pha2(:,:,1) = imR;
pha2(:,:,2) = imG;
pha2(:,:,3) = imB;


%------------------------------------------

% % Show images
% figure(2)
% clf
% subplot(1,3,1)
% imshow(uint8(pha))
% title('Ground truth')
% subplot(1,3,2)
% imshow(uint8(pha1))
% title('Material 1')
% subplot(1,3,3)
% imshow(uint8(pha2))
% title('Material 2')


figure(8)
imshow([uint8(pha),uint8(pha1),uint8(pha2);uint8(im),uint8(im1),uint8(im2)]);

save color_segmentations_JTV_Bone pha pha1 pha2 im im1 im2