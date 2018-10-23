function [xx,yy]=xy_PixelProfiles(x, y)
% This code is distributed under MIT license, please refer to the LICENSE file in the package for details.
%
%   Copyright (c) 2018 Xiyu Yi
%
%   Author of the code: Xiyu Yi
%   Email of the author: xiyu.yi@gmail.com
%   plot y against x, as pixel profiles.
xlen = length(x);
xx = zeros(1,xlen*3-3);
yy = zeros(1,xlen*3-3);
for i0 = 1:xlen-1
    xx((i0-1)*3+1)=x(i0);
    xx((i0-1)*3+2)=(x(i0)+x(i0+1))/2;
    xx((i0-1)*3+3)=(x(i0)+x(i0+1))/2;
    
    yy((i0-1)*3+1)=y(i0);
    yy((i0-1)*3+2)=y(i0);
    yy((i0-1)*3+3)=y(i0+1);
    
end


end
