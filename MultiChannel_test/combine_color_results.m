% clear all

% Create a combination imge of the segmented results
% Load the images

load color_segmentations_JTV_HY pha pha1 pha2 im im1 im2
pha_HY = pha;
pha1_HY = pha1;
pha2_HY = pha2;
im_HY = im;
im1_HY = im1;
im2_HY = im2;

load color_segmentations_JTV_Bone pha pha1 pha2 im im1 im2
pha_Bone = pha;
pha1_Bone = pha1;
pha2_Bone = pha2;
im_Bone = im;
im1_Bone = im1;
im2_Bone = im2;

load color_segmentations_JTV_Egyptian pha pha1 pha2 im im1 im2
pha_Egyptian = pha;
pha1_Egyptian = pha1;
pha2_Egyptian = pha2;
im_Egyptian = im;
im1_Egyptian = im1;
im2_Egyptian = im2;

load color_segmentations_JTV_Electric pha pha1 pha2 im im1 im2
pha_Electric = pha;
pha1_Electric = pha1;
pha2_Electric = pha2;
im_Electric = im;
im1_Electric = im1;
im2_Electric = im2;

figure(1)
clf
axis normal
imshow([[uint8(im_HY),im1_HY,im2_HY];[pha_HY,pha1_HY,pha2_HY];[im_Bone,im1_Bone,im2_Bone];[pha_Bone,pha1_Bone,pha2_Bone];[im_Egyptian,im1_Egyptian,im2_Egyptian];[pha_Egyptian,pha1_Egyptian,pha2_Egyptian];[im_Electric,im1_Electric,im2_Electric];[pha_Electric,pha1_Electric,pha2_Electric]]);
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
saveas(gcf,'all_results_texture1','png')

figure(2)
clf
axis normal
imshow([[uint8(im_HY),im1_HY,im2_HY,pha_HY,pha1_HY,pha2_HY];[im_Bone,im1_Bone,im2_Bone,pha_Bone,pha1_Bone,pha2_Bone];[im_Egyptian,im1_Egyptian,im2_Egyptian,pha_Egyptian,pha1_Egyptian,pha2_Egyptian];[im_Electric,im1_Electric,im2_Electric,pha_Electric,pha1_Electric,pha2_Electric]]);
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
saveas(gcf,'all_results_texture1','png')