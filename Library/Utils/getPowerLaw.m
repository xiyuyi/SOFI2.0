function [TSon, TSoff]=getPowerLaw(Nframe, mon, moff, Tc, Tcutoff, tExpo, truncateOption, CutOff)
% This code is distributed under MIT license, please refer to the LICENSE file in the package for details.
%
%   Copyright (c) 2018 Xiyu Yi
%
%   Author of the code: Xiyu Yi
%   Email of the author: xiyu.yi@gmail.com
%
% first generate the series;
flag = 'keepGoing';
   N = floor(tExpo*Nframe/Tc);
while(strcmp(flag,'keepGoing'))
  xon = rand(N,1);
 xoff = rand(N,1);
 TSon = Tc.*xon .^(1/(1-mon));
TSoff = Tc.*xoff.^(1/(1-moff));
% then deciete acception/rejection of life times.
    if strcmp(CutOff,'yes')
    pacS = exp(-TSon./Tcutoff);
    dice = rand(N,1);
    TSon(dice>pacS)=[];
    end
    
    if  strcmp(truncateOption,'yes')
    TSon( TSon  > tExpo*1e4)=[];   
    TSoff(TSoff > tExpo*1e4)=[];
    end

% then make sure the coverage time covers the entire series.
L=min(length(TSon),length(TSoff));
  TSon = TSon(1:L);
 TSoff = TSoff(1:L);
Ttotal = sum([TSon(:); TSoff(:)]);
if Ttotal>tExpo*Nframe
    flag='finished';
    TStotal = reshape([TSon(:)';TSoff(:)'],1,2*L);
    TTtotal = cumsum(TStotal);
          k = find(TTtotal>tExpo*Nframe);
          L = floor(min(k)/2) + 1;
       TSon = TSon(1:L);
      TSoff = TSoff(1:L);  
else
    flag='keepGoing';
end
N = N + 1;
end
return
