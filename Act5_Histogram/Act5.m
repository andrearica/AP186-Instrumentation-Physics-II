DarkIm = imread("C:\Users\AndreaRica\Documents\Andy\AP 186\A5\DarkIm_smol.jpg");
gray_DarkIm = rgb2gray(DarkIm);
px = size(gray_DarkIm);
[counts,x] = imhist(gray_DarkIm);
PDF = counts/numel(gray_DarkIm);

plot(PDF);
%imshow(PDF);

CDF = cumsum(PDF);
figure()
plot(CDF);


ya = CDF;
%xa = CDF*255; %xa - new CDF
%xa = erfinv(ya)*(2/sqrt(pi));
xa = atanh(ya);
figure()
plot(xa,ya);

%% Converts image to new CDF levels
new_im = zeros(px);
for i = 1:255
    disp(i)
    clear cy cx;
    index = find(gray_DarkIm==i);
    nCDF = CDF(i);
    n_value = xa(find(ya==nCDF));
    new_im(index) = n_value;
    
end
imshow(new_im);
