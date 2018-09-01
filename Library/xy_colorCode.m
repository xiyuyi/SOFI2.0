% written by xiyu yi

function output = xy_colorCode(Imap, TransMap, Cmap, cLevelN, TransMapRange, CIntRange)
% input I map is a 2D matrix, gray scale; encoding the parameters that need
% to be colorcoded.
% TransMap is a 2D matrix, gray scale, encoding the intensity information.
% Cmap is the colormap.
%
% Cmap is a x,3 matrix. rgb values.
%
% This program colorcode Imap with Cmap, and multiplied by a TransParancy
% mask TransMap. 
%
% the output is a 3D rgb matrix, of colorcoded Imap imposed on TransMap as
% transparency mask.
%
% prepare for parameters.
if size(TransMapRange)==0;
    TransMax = max(TransMap(:));
    TransMin = min(TransMap(:));
else
    TransMax = max(TransMapRange);
    TransMin = min(TransMapRange);
end

if size(CIntRange)==0;
    CIntMax = max(Imap(:));
    CIntMin = min(Imap(:));
else
    CIntMax = max(CIntRange);
    CIntMin = min(CIntRange);
end

% first, interpolate Cmap to 256 color.
[xdim, ydim] = size(Imap);
L = length(Cmap(:,1));
[X,   Y] = meshgrid([1:3],[1:L]');
[Xq, Yq] = meshgrid([1:3],[1:(L-1)/(cLevelN-1):L]');

C = interp2(X, Y, Cmap, Xq, Yq);

% now use local dynamic range of Imap, and squeeze Imap into the range of [0, 1].
Imap = (Imap - CIntMin)./(CIntMax-CIntMin);
TransMap = (TransMap-TransMin)./(TransMax-TransMin);
inde = round(Imap .* (cLevelN-1)) + 1; %now it's ranging from 0 to cLevelN
inde(inde>cLevelN) = cLevelN;
inde(inde<1) = 1;

tm = TransMap; tm(tm<0)=0; tm(tm>1)=1;
% now calculate RGB values of Imap.
r = zeros(xdim, ydim); r = C(inde,1).*tm(:);
g = zeros(xdim, ydim); g = C(inde,2).*tm(:);
b = zeros(xdim, ydim); b = C(inde,3).*tm(:);

cmapr = C(:,1)*[1:-1/(cLevelN-1):0];
cmapg = C(:,2)*[1:-1/(cLevelN-1):0];
cmapb = C(:,3)*[1:-1/(cLevelN-1):0];

output.img = reshape([r,g,b], xdim, ydim, 3);
output.colorRange = [CIntMin,  CIntMax];
output.IntenRange = [TransMin, TransMax];
output.ColorMap = C;
output.ColorMatrix = reshape([cmapr,cmapg,cmapb],cLevelN,cLevelN,3);
end