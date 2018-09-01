% This is a demonstration code to produce a super-resolution movie
% associated with the following publication:
%       X. Yi, S. Son, S. Weiss, 
%       "Moments reconstruction and local dynamic range compression of high 
%       order Super-resolution of Optical Fluctuation Imaging", 
%       to be submitted.
%


clear all
addpath(genpath(['./Library']))
NF = fspecial('gaussian',[1,21],2); % define a noise filter. 
% get dimensions
    im = imread(['./Demo_dataset/Block1.tif']);
    [xdim, ydim] = size(im);
%% calcualte M6 for each block of 200 frames, and 20 blocks in total.
M6series = zeros(xdim, ydim, 20);
ImMean_Series = zeros(xdim, ydim, 20);
for blockN = 1 : 20
    J = zeros(xdim, ydim, 200, 'uint16');
    disp(['calculating M6 of block ',num2str(blockN),'/20...'])
    for frameInd = 1 : 200
        im = imread(['./Demo_dataset/Block',num2str(blockN),'.tif'], 'Index', frameInd);
        J(:,:,frameInd) = im;
    end
    
    %   calculatie average image for this block
    ImMean = mean(double(J), 3);
    ImMean_Series(:, :, blockN) = ImMean;
    
    %   calculate M6 of this block
    M6 = zeros(xdim, ydim);
    
    for i0 = 1 : 200
        M6 = M6 + (double(J(:, :, i0)) - ImMean).^6; % directly compute. 
    end
    M6 = M6./200;
    M6series(:, :, blockN) = M6;
end

%% perform noise filter on M6 along the time axis for each pixel independently.
M6_filtered = zeros(xdim, ydim, 20);
for i0 = 1:xdim
    if rem(i0, 100) == 0
    disp(['Apply noise filter on M6 series, row (',num2str(i0),'-',num2str(min(i0+100-1,283)),')/283...'])    
    end
    for i1 = 1:ydim
        s = M6series(i0, i1, :); s = s(:); % take the time sequence
        s = conv(s,NF,'same'); % filter.
        M6_filtered(i0, i1, :) = reshape(s, [1, 1, 20]); % store into the filtered variable
    end
end

%% perform shrinking kernal deconvolution on M6 for each frame.
M6_NF_DeconvSK = zeros(xdim, ydim, 20);
for i0 = 1 : 20
    im = M6_filtered(:, :, i0);
    % now prepare input parameters for xy_DeconvSk
        [xdim, ydim] = size(im);
        inputImg = [im, fliplr(im); flipud(im), rot90(im,2)];% perform mirror extension to the image in order to surpress ringing artifacts associated with fourier transform due to truncation effect.
        para.J0 = inputImg; 
        para.PSF0 = fspecial('gaussian', [51,51], 2); % prepare an estimation of the convolution kernel here. In this datasets, cross-correlation doesn't work, therefore we use a rough estimation.
        para.lambda = 1.5; %DeconvSK parameter
        para.ItN = 20; % iteration number.
    disp(['calculating DeconvSK on block ',num2str(i0),'/20...'])
    output = xy_DeconvSK(para);
    DeconvNFM6 = output(1:xdim, 1:ydim);
    M6_NF_DeconvSK(:, :, i0) = DeconvNFM6;
end
%% perform then next round of noise filter to the deconvolution result
M6_NF_DeconvSK_NF = zeros(xdim, ydim, 20);
for i0 = 1 : xdim
    if rem(i0, 100) == 0
    disp(['Apply noise filter on deconvolved M6 series, row (',num2str(i0),'-',num2str(min(i0+100-1,283)),')/283...'])    
    end
    for i1 = 1 : ydim
        s = M6_NF_DeconvSK(i0,i1,:); s = s(:);
        s = conv(s,NF,'same');
        M6_NF_DeconvSK_NF(i0,i1,:) = reshape(s,[1,1,20]);
    end
end    
%% perform LDRC on the current result and save.
M6_NF_DeconvSK_NF_LDRC = zeros(xdim, ydim, 20);
for i0 = 1 : 20
    InputImage = M6_NF_DeconvSK_NF(:,:,i0);
    order = 7;
    Mask = ImMean_Series(:,:,i0);
    windowSize = 25;
    disp(['calculate LDRC for frame ',num2str(i0),'/20'])
    ldrcResult = xy_QuickLDRC(InputImage, Mask, windowSize);    
    M6_NF_DeconvSK_NF_LDRC(:,:,i0) = ldrcResult;
end

%% save the result
save demo_result.mat M6_NF_DeconvSK_NF_LDRC ImMean_Series

%% produce visualization of the result
vid = VideoWriter('demo2.avi');
vid.Quality = 100;
vid.FrameRate=10;
open(vid)
cmap = colormap(pink);
cmap = [0,0,0;imresize(cmap, [256, 3])];
for i0 = 1 : 20
    im1 = xy_gray2rgb(ImMean_Series(:, :, i0), cmap);
    im2 = xy_gray2rgb(M6_NF_DeconvSK_NF_LDRC(:, :, i0), cmap);    
    figure(1); imshow([im1, im2.*1.4]);%adjust display contrast for better visualization
    drawnow;
    c = getframe;
    writeVideo(vid, c);
end
close(vid)