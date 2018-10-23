% This code is distributed under MIT license, please refer to the LICENSE file in the package for details.
%
%   Copyright (c) 2018 Xiyu Yi
%
%   Author of the code: Xiyu Yi
%   Email of the author: xiyu.yi@gmail.com

function [M2, M3, M4, M5, M6, M7] = xy_getSOFI_MomentsReconstruction(inputPath,outputPath,ImMeanLocFori,LibPath);
addpath(LibPath)
for ord = 2:7
eval(['load ',inputPath,'/SOFIforFit_XC',num2str(ord),'.mat ActualImage']);
eval(['k',num2str(ord),'=ActualImage.XC',num2str(ord),'_rmW(',num2str(ord),'*3:end-',num2str(ord),'*3+1,',num2str(ord),'*3:end-',num2str(ord),'*3+1);'])
end
load(ImMeanLocFori)
[xdim, ydim] = size(ImMean);
[ixdim, iydim] = size(k7);

for ord = 1:7
[X, Y] = meshgrid([1:1/ord:xdim],[1:1/ord:ydim]');
eval(['X',num2str(ord),'=X;'])
eval(['Y',num2str(ord),'=Y;'])
end

for i0 = 2:6
    disp(['interpolation of cumulant order ',num2str(i0),'/6 to match up order 7'])
    eval(['X=X',num2str(i0),';'])
    eval(['Y=Y',num2str(i0),';'])
    eval(['Input= k',num2str(i0),';'])
    kInt = interp2(X,Y,Input',X7,Y7,'cubic')';
    eval(['c',num2str(i0),'=kInt;'])
end
c7 = k7;

disp(['Reconstruct Moment order 2'])
M2 = c2;
disp(['Reconstruct Moment order 3'])
M3 = c3;
disp(['Reconstruct Moment order 4'])
M4 = c4 + 3.*c2.^2;
disp(['Reconstruct Moment order 5'])
M5 = c5 + 10.*c3.*c2;
disp(['Reconstruct Moment order 6'])
M6 = c6 + 15.*c4.*c2+10.*(c3.^2)+15.*(c2.^3);
disp(['Reconstruct Moment order 7'])
M7 = c7 + 21.*c5.*c2 + 35.*c4.*c3 + 105.*c3.*c2.^2;
disp(['saving datafile...'])
save([outputPath,'/Moments.mat'],'M2','M3','M4','M5','M6','M7');
