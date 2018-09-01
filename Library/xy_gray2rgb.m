function output = xy_gray2rgb(im, map)
im(isnan(im))= eps;
im = double(im);
im = (im - min(im(:)))./(max(im(:))-min(im(:))).*length(map(:,1));
im = round(im);
output = ind2rgb(im, map);