% Plot the results of routine XRsparseD_aTV_comp.m
%
% Jennifer Mueller and Samuli Siltanen, October 2012

% Plot parameters
fsize     = 12;
thinline  = .5;
thickline = 2;

% Load reconstruction
 load XRsparse_aTV_JTV_egyptian recn1 recn2 alpha target1 target2 obj
%load XRsparse_aTV_JTV_HY recn1 recn2 alpha target1 target2 obj

% Compute relative errors
err_squ1 = norm(target1(:)-recn1(:))/norm(target1(:));
err_squ2 = norm(target2(:)-recn2(:))/norm(target2(:));

% Plot reconstruction image 1
figure(1)
clf
%imagesc([target1,recn1],[0,1])
imagesc([target1,recn1]);
colormap gray
axis equal
axis off
title(['Approximate TV: error ', num2str(round(err_squ1*100)), '%'])

% Plot reconstruction image 2
figure(2)
clf
%imagesc([target2,recn2],[0,1])
imagesc([target2,recn2]);
colormap gray
axis equal
axis off
title(['Approximate TV: error ', num2str(round(err_squ2*100)), '%'])

% Plot profile of reconstruction 1
figure(3)
clf
plot(target1(end/2,:),'k','linewidth',thinline)
hold on
plot(recn1(end/2,:),'k','linewidth',thickline)
xlim([1 size(recn1,1)])
axis square
box off
title('Profile of approximate TV reconstruction 1')

% Plot profile of reconstruction 2
figure(4)
clf
plot(target2(end/2,:),'k','linewidth',thinline)
hold on
plot(recn2(end/2,:),'k','linewidth',thickline)
xlim([1 size(recn2,1)])
axis square
box off
title('Profile of approximate TV reconstruction 2')

% Plot evolution of oblective function
figure(5)
clf
semilogy(obj,'b')
axis square
title('Values of objective function during iteration')



