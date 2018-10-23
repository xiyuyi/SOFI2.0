function [IntSeries,para]=getIntProfile(Ton, Toff, tExpo, Nframe)
% This code is distributed under MIT license, please refer to the LICENSE file in the package for details.
%
%   Copyright (c) 2018 Xiyu Yi
%
%   Author of the code: Xiyu Yi
%   Email of the author: xiyu.yi@gmail.com
%
%randomly choose the initlia phase to be either on or off.
tag=rand(1);L=length(Ton);
if tag>0.5
    tauS=reshape([Ton(:)';Toff(:)'], 1, 2*L);
    phaS=reshape([ones(1,L); zeros(1,L)], 1, 2*L);
    phaPre='on';
else
    tauS=reshape([Toff(:)';Ton(:)'], 1 ,2*L);
    phaS=reshape([zeros(1,L); ones(1,L)], 1, 2*L);
    phaPre='off';
end

%Construct the complex of time series before insertion of binning time
%points.
timS = cumsum(tauS);
comS = [timS; tauS; phaS];

% define the complete insert time points of binning
timI = [tExpo : tExpo : tExpo*Nframe];
tauI = zeros(1,Nframe);
phaI = ones(1,Nframe).*2;
comI = [timI; tauI; phaI];
% perform insertion to perform the total complete vector.
comI = sortrows([comS'; comI'])';

% modify the inserted phase and taui after insertion.
timT = comI(1, :); 
tauT = comI(2, :); 
phaT = comI(3, :);

% step1. modify phase series
% calculate the index that suppose to be on or off state.
preOn = find(phaT==1); %on state index,  before insertion.
preOf = find(phaT==0); %off state index, before insertion.
preFr = find(phaT==2); %the index of frame cut position.
% the index series above should have the same size.
L = length(preOn);
  if strcmp(phaPre,'on') %initial phase 'on'
      phaT(1:preOn(1)) = 1; %initial phase is on;
      for i0=1:L-1
      phaT(preOn(i0)+1 : preOf(i0))  = 0;
      phaT(preOf(i0)+1 : preOn(i0+1))= 1;
      end
      phaT(preOn(L)+1  : preOf(L))   = 0;
      
  else %initial phase 'off'
      phaT(1:preOf(1)) = 0; %initial phase is off;
      for i0=1:L-1
      phaT(preOf(i0)+1 : preOn(i0))  = 1;
      phaT(preOn(i0)+1 : preOf(i0+1))= 0;
      end
      phaT(preOf(L)+1  : preOn(L))   = 1;    
  end
%step2. modify taui series.
tauT(2:end) = timT(2:end)-timT(1:end-1);
    tauT(1) = timT(1); 
comT = [timT; tauT; phaT];

% construct intensity ratios
IntSeries=[1,Nframe];
% starting frame:
tiOn = sum(comT(2,1:preFr(1)).*comT(3,1:preFr(1)));
%tiAl = sum(comT(2,1:preFr(1)));
tiAl = tExpo;

IntSeries(1) =  tiOn/tiAl;
% second to last frames
 for i0 = 2 : Nframe;   
  tiOn = sum(comT(2,preFr(i0-1)+1:preFr(i0)).*comT(3,preFr(i0-1)+1:preFr(i0)));
  %tiAl = sum(comT(2,preFr(i0-1)+1:preFr(i0)))
  tiAl = tExpo;
  IntSeries(i0) =  tiOn/tiAl;
 end


para.comT=comT;
para.comI=comI;
para.preFr=preFr;
para.preOn=preOn;
para.preOf=preOf;
1;
end
