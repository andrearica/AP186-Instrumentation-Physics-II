ext = '.png';
Oe = [];
Ohue = [];
for i = 1
    im = imread(['freshoranges\O' num2str(i) ext]);

    
    [bin, color] = NonPar(im);  
    
    hsvcolors = rgb2hsv(color);
    h = hsvcolors(:,:,1);
    h(hsvcolors(:,:,1) == 0) = [];
    Ohue = [Ohue,mean(h,'all')];
    
    stats = regionprops(bin, 'Eccentricity');

    Oe = [Oe,stats.Eccentricity];
end
%%

Ae = [];
Ahue = [];
for i = 1:20
    im = imread(['freshapples\GA' num2str(i) ext]);

    
    [bin, color] = NonPar(im);  
    
    hsvcolors = rgb2hsv(color);
    h = hsvcolors(:,:,1);
    h(hsvcolors(:,:,1) == 0) = [];
    Ahue = [Ahue,mean(h,'all')];
    
    stats = regionprops(bin, 'Eccentricity');

    Ae = [Ae,stats.Eccentricity];
end
%%

Be = [];
Bhue = [];
for i = 1:20
    im = imread(['freshbanana\B' num2str(i) ext]);

    
    [bin, color] = NonPar(im);  
    
    hsvcolors = rgb2hsv(color);
    h = hsvcolors(:,:,1);
    h(hsvcolors(:,:,1) == 0) = [];
    Bhue = [Bhue,mean(h,'all')];
    
    stats = regionprops(bin, 'Eccentricity');

    Be = [Be,stats.Eccentricity];
end
%%
figure, scatter(Oe,Ohue,'r');hold on;
scatter(Ae,Ahue,'g');
scatter(Be,Bhue,'y');
legend('Orange','Green Apple','Banana');
ylabel("Hue");
xlabel("Eccentricity");
%%

function [histo,colors] = patchcolor(patch)
patch1 = double(patch);
figure(1)
subplot(1,2,1); imshow(patch);

pR = patch1(:,:,1);
pG = patch1(:,:,2);
pB = patch1(:,:,3);

I = pR+pG+pB;
I(I==0) = 1000000;
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
    end
end
subplot(1,2,2);
imshow(imrotate(histo,90));
saveas(1,"patch and histo.png");
end

function [Bi_im,Fin] = NonPar(im)
BINS = 60;
patch = imcrop(im);
[histo,~] = patchcolor(patch);
iR =double(im(:,:,1));
iG =double(im(:,:,2));
iB = double(im(:,:,3));
% Color Segmentation
% Choose Patch

% Non-Parametric
% 
% Image
imI = iR+iG+iB;
imI(imI==0)=100000000;
RIm = iR./imI; GIm = iG./imI;

[ro,co] = size(iR);
backproj = zeros(ro,co);


for i = 1:co
    for j = 1:ro
        rbp = round(RIm(j,i)*(BINS-1)+1);
        gbp = round(GIm(j,i)*(BINS-1)+1);
        backproj(j,i) = histo(rbp,gbp);
    end
end

backproj = imfill(backproj,'holes');
str = strel('disk',10);
backproj = imclose(backproj,str);
str1 = strel('disk',20);
backproj = imerode(backproj,str1);

%
Bi_im = repmat(backproj,1);
Bi_im = mat2gray(Bi_im);
Bi_im(Bi_im>0.01)=1;
Bi_im(Bi_im<=0.01)=0;
figure(5)
imshow(Bi_im);
saveas(5,"binary.png");

newR = (Bi_im.*iR)/255;
newG = (Bi_im.*iG)/255;
newB = (Bi_im.*iB)/255;
Fin = cat(3, newR, newG, newB);
figure(6)
imshow(Fin);
saveas(6,"fin.png");

end
