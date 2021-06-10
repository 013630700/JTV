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

% Construct a fake material image. It has 3 color channels: R,G,B and size
% NxN
N = 256;

% Construct indices for the two materials
t = linspace(-1,1,N);
[X,Y] = meshgrid(t);
ind1 = (sqrt(X.^2+Y.^2)<.9) & (sqrt(X.^2+Y.^2)>.6); % True where there is material 1
ind2 = (sqrt(X.^2+Y.^2)<.6); % True where there is material 2
% If we do this from two thresholded reconstructions
%ind1 = (recon1>.5);
%ind2 = (recon2>.5);

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

% Show images
figure(1)
clf
subplot(1,3,1)
imshow(uint8(im))
title('Both materials')
subplot(1,3,2)
imshow(uint8(im1))
title('Material 1')
subplot(1,3,3)
imshow(uint8(im2))
title('Material 2')