% This code is distributed under MIT license, please refer to the LICENSE file in the package for details.
%
%   Copyright (c) 2018 Xiyu Yi
%
%   Author of the code: Xiyu Yi
%   Email of the author: xiyu.yi@gmail.com

function output = xy_QuickLDRC(im, Mask, w)
% im : image input
% mask: the reference mask of brightness (choose either AC2 or Mean)
% w: windowsize.

[xdim, ydim] = size(im);
output = zeros(xdim, ydim);
Fla = zeros(xdim, ydim);
FlaP = ones(w);
for i0 = 0:xdim-w;
    for i1 = 0:ydim-w;
        p = im(i0+[1:w],i1+[1:w]);
        p = p./max(p(:));
        output(i0+[1:w],i1+[1:w]) = output(i0+[1:w],i1+[1:w]) + p.* max(max(Mask(i0+[1:w],i1+[1:w])));
        Fla(i0+[1:w],i1+[1:w]) = Fla(i0+[1:w],i1+[1:w]) + FlaP;
        
    end
end
output = output./Fla;
end
