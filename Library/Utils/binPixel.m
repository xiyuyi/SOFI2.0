function output=binPixel(p,ind)
% This code is distributed under MIT license, please refer to the LICENSE file in the package for details.
%
%   Copyright (c) 2018 Xiyu Yi
%
%   Author of the code: Xiyu Yi
%   Email of the author: xiyu.yi@gmail.com

[x,y]=size(p);
a1=reshape(p,x*ind,y/ind);
a2=reshape(a1,x,ind,y/ind);
a3=sum(a2,2);
a4=reshape(a3,x,y/ind);

l=a4';
[x,y]=size(l);
a1=reshape(l,x*ind,y/ind);
a2=reshape(a1,x,ind,y/ind);
a3=sum(a2,2);
a4=reshape(a3,x,y/ind);

output=a4';
return
