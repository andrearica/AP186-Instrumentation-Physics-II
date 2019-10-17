%% BnW Thresholding

I = imread('bnw.PNG');
figure(1);imshow(I);
[count,cells] = imhist(I,256);
figure(2);plot(cells,count);
ylabel("Counts");
xlabel("Grayscale Values");
saveas(2,"bnwhisto.png");

BW = zeros(size(I));
BW(find(I<125))=1;
figure();imshow(BW);
imwrite(BW,'results_bnw.png');
   
%% Color Segmentation
%% Choose Patch
figure()
im = imread('wbc1.png');
iR =double(im(:,:,1));
iG =double(im(:,:,2));
iB = double(im(:,:,3));
patch = imcrop(im);
patch1 = double(patch);
figure(1)
subplot(1,2,1); imshow(patch);

pR = patch1(:,:,1);
pG = patch1(:,:,2);
pB = patch1(:,:,3);

I = pR+pG+pB;
I(find(I==0)) = 1000000;
nR = pR./I;
nG = pG./I;
nB = pB./I;

BINS = 60;
rint = round(nR*(BINS-1)+1);
gint = round(nG*(BINS-1)+1);
colors = gint(:) + (rint(:)-1)*BINS;
histo = zeros(BINS,BINS);
for row = 1:BINS
    for col = 1:(BINS-row+1)
        histo(row,col)= length(find(colors==(((col+(row-1)*BINS)))));
    end;
end;
subplot(1,2,2);
imshow(imrotate(histo,90));
saveas(1,"patch and histowbc.png");
%% Parametrization
mean_r = mean(nR,'all');
mean_g = mean(nG,'all');
std_r = std2(nR);
std_g = std2(nG);

% Image
Seg_im = imread('wbc1.png');
Seg_im = double(Seg_im);

imR = Seg_im(:,:,1);
imG = Seg_im(:,:,2);
imB = Seg_im(:,:,3);

imI = imR+imG+imB;
imI(imI==0)=100000000;
RIm = imR./imI; GIm = imG./imI;

p_r = (1/std_r*sqrt(2*pi))*exp(-(((RIm-mean_r).^2)/(2*std_r^2)));
p_g = (1/std_r*sqrt(2*pi))*exp(-(((GIm-mean_g).^2)/(2*std_g^2)));
P_rg = p_r.*p_g;
figure(2)
imshow(mat2gray(P_rg));
saveas(2,"binrbc.png");

Bi_im = repmat(P_rg,1);
Bi_im = mat2gray(Bi_im);
Bi_im(Bi_im>0.001)=1;
Bi_im(Bi_im<=0.001)=0;
imshow(Bi_im)

newR = (Bi_im.*iR)/255;
newG = (Bi_im.*iG)/255;
newB = (Bi_im.*iB)/255;
Fin = cat(3, newR, newG, newB);
figure(3);
imshow(Fin);
saveas(3,"Parametricrbc.png");
%% Non-Parametric
%% 
% Image
Seg_im = imread('wbc1.png');
Seg_im = double(Seg_im);

imR = Seg_im(:,:,1);
imG = Seg_im(:,:,2);
imB = Seg_im(:,:,3);

imI = imR+imG+imB;
imI(imI==0)=100000000;
RIm = imR./imI; GIm = imG./imI;

[ro,co] = size(imR);
backproj = zeros(ro,co);


for i = 1:co
    for j = 1:ro
        rbp = round(RIm(j,i)*(BINS-1)+1);
        gbp = round(GIm(j,i)*(BINS-1)+1);
        backproj(j,i) = histo(rbp,gbp);
    end
end

figure(4);
imshow(backproj);
saveas(4,"binary_rbc.png");
%%
Bi_im = repmat(backproj,1);
Bi_im = mat2gray(Bi_im);
Bi_im(Bi_im>0.01)=1;
Bi_im(Bi_im<=0.01)=0;
figure(5)
imshow(Bi_im);

newR = (Bi_im.*imR)/255;
newG = (Bi_im.*imG)/255;
newB = (Bi_im.*imB)/255;
Fin = cat(3, newR, newG, newB);
figure(6)
imshow(Fin);
saveas(6,"rbcfind.png");
%% Plus plus
