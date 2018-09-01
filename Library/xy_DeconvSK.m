% this script demonstrate iterative deconvolution method with shrinking
% kernal.
% Author: Xiyu Yi @ UCLA
% Email: chinahelenyxy@gmail.com
%
% all rights resrved.
%
%
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

