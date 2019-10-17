I = imread("cell_im1.jpg");
imshow(I);
[bin,fin] = color_seg(I);
%%
bin1 = bwareaopen(bin,5);
bin1 = imfill(bin1,'holes');
figure(2);
imshow(bin1);
% saveas(2,'Bin2.png');
%%
bin2 = bwlabel(bin1,4);
stats = regionprops(bin2,'Area');
[a] = [stats.Area];
idx1 = find(a<=230);
idx = find(a>230);

binbig = bin2;
binsmol = bin2;
for i=idx1
    binbig(bin2==i) = 0;
  
end
figure(3);
imshow(binbig);
% saveas(3,"binbig.png");

for j=idx
    binsmol(bin2==j) = 0;  
end
figure(4);
imshow(binsmol);
% saveas(4,"binsmol.png");

%%
binbig = bwlabel(binbig,4);
D = bwdist(~binbig);
figure(5);
imshow(D,[],'InitialMagnification','fit');
title('Distance transform of ~bw');
% saveas(5,"watershed.png");
D = -D;
D(~binbig) = Inf;
L = watershed(D); 
L(~binbig) = 0;
L = L>0;
figure(6)
imshow(L);
% saveas(6,"newbinbig.png");
% rgb = label2rgb(L,'jet',[.5 .5 .5]);
% figure, imshow(rgb,'InitialMagnification','fit');
% title('Watershed transform of D');

%%
Llang = L>0;
Binsmollang = binsmol>0;
finalcells = Llang | Binsmollang;

finalcells1 = bwlabel(finalcells,4);
figure(); imshow(finalcells1);
for i = 1:max(finalcells1,[],'all')
    str = strel('disk',10);
    new = imclose(finalcells1==i,str);
    finalcells1 = finalcells1 | new;
    finalcells1 = bwlabel(finalcells1,4);
end
figure(7);
imshow(finalcells1);
% saveas(7,"final.png");
stat = regionprops(finalcells1,'Area','Centroid','MajorAxisLength','MinorAxisLength','Eccentricity','Perimeter','BoundingBox');

%%
%Centroid
c1 = cat(1,stat.Centroid);
figure(8);
imshow(finalcells1)
hold(imgca,'on')
plot(imgca,c1(:,1), c1(:,2), 'b*')
% saveas(8,"centroids.png");

%BoundingBox
% figure(9);
% imshow(finalcells1)
% hold(imgca,'on')
for k = 1 : length(stat)
  bb = stat(k).BoundingBox;
  rectangle('Position', [bb(1),bb(2),bb(3),bb(4)],...
  'EdgeColor','r','LineWidth',1 )
end
hold(imgca,'off')
saveas(8,"BBc.png");

%%
ar = [stat.Area];
figure();histogram(ar,100);
idx2 = find((ar>0&ar<109));

smol = finalcells1;
finalcells2 = finalcells1;
for i=idx2
    smol(finalcells1==i) = 0.5;  
    finalcells2(finalcells1==i) = 0;
end
% smol(smol>0.5) = 0;
% smol(smol==0.5) =1;
figure();
imshow(smol);

finalcells2 = bwlabel(finalcells2,4);
nstat = regionprops(finalcells2,'Area','MajorAxisLength','Eccentricity','Perimeter','BoundingBox','Centroid');

%%
ar2 = [nstat.Area];
ecc = [nstat.Eccentricity];
mjl = [nstat.MajorAxisLength];
per = [nstat.Perimeter];
%%
function [Bi_im,Fin] = color_seg(im)
%Choose Patch
figure()
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


%
% Image
Seg_im = im;
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
%
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

end
