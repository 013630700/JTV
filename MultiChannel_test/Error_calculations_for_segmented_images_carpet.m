% Here we calculate the errors for the tresholded images and rekonstruktions.
clear all;

% First load all images. Original phantoms and reconstructions.
% Carpet phantom:
load XRsparse_aTV_JTV_carpet recn1 recn2 target1 target2
load JTV_carpet_for_segmentations im1 im2 im3 im4 N

figure(1)
imshow([target1,target2],[]);
figure(2)
imshow([recn1,recn2],[]);
figure(3)
imshow([target1,target2;recn1,recn2],[]);
% First treshold the images.
N=128;
%Calculate the right amount of white pixels in the original phantoms.
%First phantom, im1
white_pixels1 = nnz(target1)/(N*N);
%Second phantom
white_pixels2 = nnz(target2)/(N*N);

%Treshold the images so that the amount of white pixels is correct. Here
%the values are between 0 and 1, but they have also other values.

% Calculate the amount of wrong pixels. First we need to decide which
% pixels we set as zero and which will have number 1. We want that kind of
% treshold, which gives us the right amount of white pixels.
% There ratio should be 0.41 in the first reconstruction and 0.25 in the second.
% So in the first reco we want nnz(im3) to be 6717. We get this number of
% white pixels with the following treshold:
% CARPET THRESHOLD: 0.3492/ 0.23272
im3_thresholded = im3;
im3_thresholded(im3>0.23272) = 1;
im3_thresholded(im3<0.23272) = 0;
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


%% now we will calculate the error with the second reconstruction
% The amount of white pixels is 4028.
% CARPET TRESHOLD: 0.2762/0.154
im4_thresholded = im4;
im4_thresholded(im4>0.154) = 1;
im4_thresholded(im4<0.154) = 0;
nnz(im4_thresholded)

% We want to treshold the target1 also to be zero or one.
target2_thresholded = target2;
target2_thresholded(target2>1) = 1;
target2_thresholded(target2<1) = 0;
nnz(target2_thresholded)
figure()
imshow([target2_thresholded,im4_thresholded],[])
title('thresholded image im4 = recn2')

% Calculate the error for reconstruction 1. Caluculate the difference and
% how many pixels are non-zero.
error2=(nnz(target2_thresholded-im4_thresholded))/(N*N);

figure(6);
% Original phantom1
subplot(2,2,1);
imagesc(target1_thresholded);
colormap gray;
axis square;
axis off;
title({'Carpet1 phantom, ground truth'});
% Reconstruction of phantom1
subplot(2,2,2)
imagesc(im3_thresholded);
colormap gray;
axis square;
axis off;
title(['JTV, pixel error ', num2str(round(error1,2))]);
% Original target2
subplot(2,2,3)
imagesc(target2_thresholded);
colormap gray;
axis square;
axis off;
title({'Carpet2 phantom, ground truth '});
% Reconstruction of target2
subplot(2,2,4)
imagesc(im4_thresholded);
colormap gray;
axis square;
axis off;
title(['JTV, pixel error ' num2str(round(error2,2))]);

Image = getframe(gcf);
imwrite(Image.cdata, 'segmentations_carpet_JTV.jpg');