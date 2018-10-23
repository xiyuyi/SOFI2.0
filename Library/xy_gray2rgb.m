% This code is distributed under MIT license, please refer to the LICENSE file in the package for details.
%
%   Copyright (c) 2018 Xiyu Yi
%
%   Author of the code: Xiyu Yi
%   Email of the author: xiyu.yi@gmail.com

function output = xy_gray2rgb(im, map)
im(isnan(im))= eps;
im = double(im);
im = (im - min(im(:)))./(max(im(:))-min(im(:))).*length(map(:,1));
im = round(im);
output = ind2rgb(im, map);
