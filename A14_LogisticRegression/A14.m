ext = '.jpg';
BR = [];
BG = [];
BB = [];
for i = 1:40
    im = imread(['ripe\m0' num2str(i) ext]);

    
    [~, color] = NonPar(im);  
    
    R = nonzeros(color(:,:,1));
    G = nonzeros(color(:,:,2));
    B = nonzeros(color(:,:,3));
    
    BR = [BR,mean(R)];
    BG = [BG,mean(G)];
    BB = [BB,mean(B)];
 
end
%%
ext1 = '.jpg';
uBR = [];
uBG = [];
uBB = [];
for i = 1:40
    if i==32
        im = imread(['unripe\g0' num2str(i) ext]);
    else
        im = imread(['unripe\g0' num2str(i) ext1]);
    end

    
    [~, color] = NonPar(im);  
    
    uR = nonzeros(color(:,:,1));
    uG = nonzeros(color(:,:,2));
    uB = nonzeros(color(:,:,3));
    
    uBR = [uBR,mean(uR)];
    uBG = [uBG,mean(uG)];
    uBB = [uBB,mean(uB)];
 
end

save('bananas1.mat','BR','BG','BB','uBR','uBG','uBB');

%%
d = [ones(1,length(BB)),zeros(1,length(uBB))];

n = 0.001;
eps = 1e-2;

w = rand(4,1);
xab = [ones(1,2*length(BB));BR,uBR;BG,uBG;BB,uBB];
for j = 1:500000
    z = [];
    for i =1:length(d)
        a = dot(xab(:,i),w);
        za = g(a);
        z = [z;za];
        dw = n*(d(i)-za).*xab(:,i); 
        w = w+dw; 
    end
    res = sum((d'-z).^2,'all');
%     disp(res)
    if res<eps
         disp(j)
        break
    end
end


%% Test
tBR = [];
tBG = [];
tBB = [];
for i = 1:8
    if i>6
        im = imread(['test\T' num2str(i) '.png']);
    else
        im = imread(['test\T' num2str(i) '.jpg']);
    end
    
    [~, color] = NonPar(im);  
    
    tR = nonzeros(color(:,:,1));
    tG = nonzeros(color(:,:,2));
    tB = nonzeros(color(:,:,3));
    
    tBR = [tBR,mean(tR)];
    tBG = [tBG,mean(tG)];
    tBB = [tBB,mean(tB)];
 
end
%%
test = [ones(1,length(tBB));tBR;tBG;tBB];
z=[];
a1=[];
for i =1:length(tBB)
    a = dot(test(:,i),w);
    a1=[a1;a];
    z = [z;g(a)];

end

%%
x  = linspace(min(a1),max(a1),50);
y = 1./(1+exp(-x));
plot(x,y);hold on;
scatter(a1,z);
%% Fxns
function [z] = g(a)
    z = 1/(1+exp(-a));
end

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
str1 = strel('disk',10);
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
