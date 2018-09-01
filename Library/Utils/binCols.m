function output=binCols(p,ind)
% Author: Xiyu
 [x,y]=size(p);
 a1 = reshape(p, x, ind, y/ind);
 a2 = sum(a1,2);
 output = reshape(a2,x,y/ind);
% a1=reshape(p,x*ind,y/ind);
% a2=reshape(a1,x,ind,y/ind);
% a3=sum(a2,2);
% a4=reshape(a3,x,y/ind);
% 
% l=a4';
% [x,y]=size(l);
% a1=reshape(l,x*ind,y/ind);
% a2=reshape(a1,x,ind,y/ind);
% a3=sum(a2,2);
% a4=reshape(a3,x,y/ind);
% 
% output=a4';

return