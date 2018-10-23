% This code is distributed under MIT license, please refer to the LICENSE file in the package for details.
%
%   Copyright (c) 2018 Xiyu Yi
%
%   Author of the code: Xiyu Yi
%   Email of the author: xiyu.yi@gmail.com

function output = xy_DeconvSK(para)
J0 = para.J0; 
PSF0 = para.PSF0;
PSF0 = PSF0./max(PSF0(:));
lambda = para.lambda;
ItN = para.ItN;

J = J0;
for i0 = 1:ItN
    disp(['        iteration #',num2str(i0),'/',num2str(ItN)])
    alpha = lambda.^i0/(lambda-1);
    [J, PSF] = deconvblind(J,PSF0.^alpha,1);
end

output = J;
end

