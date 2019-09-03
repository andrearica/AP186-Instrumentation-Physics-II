%% Image Procurement
clear all;
DarkIm = imread('C:\Users\AndreaRica\Documents\Andy\AP 186\A6\bday.jpg');
figure(1); imshow(DarkIm);

red = double(DarkIm(:,:,1));
green = double(DarkIm(:,:,2));
blue = double(DarkIm(:,:,3));

% red = (DarkIm(:,:,1));
% green = (DarkIm(:,:,2));
% blue = (DarkIm(:,:,3));
%% Contrast Stretching
%% minimum, maximum

% figure(10); hold on
% imhist(blue);
% imhist(red);
% imhist(green);
% saveas(10, 'PDF.png');

%%
mini_r = min(red,[],'all');
mini_g = min(min(green));
mini_b = min(min(blue));

maxi_r = max(max(red));
maxi_g = max(max(green));
maxi_b = max(max(blue));

%% equations

stretch_r = ((red-mini_r)/(maxi_r-mini_r))*255;
stretch_g = ((green-mini_g)/(maxi_r-mini_g))*255;
stretch_b = ((blue-mini_b)/(maxi_r-mini_b))*255;

new_r = uint8(floor(stretch_r));
new_g = uint8(floor(stretch_g));
new_b = uint8(floor(stretch_b));

% nm_r = max(new_r);
% nm_g = max(new_g);
% nm_b = max(new_b);
% 
% new_r = new_r/max(nm_r);
% new_g = new_g/max(nm_g);
% new_b = new_b/max(nm_b);


figure(11); hold on
imhist(new_b);
imhist(new_r);
imhist(new_g);
saveas(11, 'nPDF.png');
%% All channels
% final = cat(3, new_r, new_g, new_b);
final = cat(3, stretch_r, stretch_g, stretch_b);
figure(2); imshow(final);
saveas(2,'CS.png');

%% White Patch Algorithm
%% 
whitep = imread('C:\Users\AndreaRica\Documents\Andy\AP 186\A6\fb_grab\try_fb2_white.jpg');

redw = double(whitep(:,:,1));
greenw = double(whitep(:,:,2));
bluew = double(whitep(:,:,3));

rw = mean(redw,'all');
gw = mean(greenw,'all');
bw = mean(bluew,'all');

new_r = red/rw;
new_g = green/gw;
new_b = blue/bw;

%% All channels
final = cat(3, new_r, new_g, new_b);
figure(3); imshow(final);
saveas(3,'WP.png');

%% Gray World Algorithm
%%
nred = red/255;
ngreen = green/255;
nblue = blue/255;

ave_r = mean(nred,'all');
ave_g = mean(ngreen,'all');
ave_b = mean(nblue,'all');

aves = cat(3, ave_r, ave_g, ave_b);
maxa = max(aves);
meana = mean(aves);

%% avg/avgi
new_r = (meana)*nred/ave_r;
new_g = (meana)*ngreen/ave_g;
new_b = (meana)*nblue/ave_b;

final = cat(3, new_r, new_g, new_b);
figure(4); imshow(final);
saveas(4,'GW_avg.png');

%% max(avg)/avgi
new_r = (maxa)*nred/ave_r;
new_g = (maxa)*ngreen/ave_g;
new_b = (maxa)*nblue/ave_b;

final = cat(3, new_r, new_g, new_b);
figure(5); imshow(final);
saveas(5,'GW_max.png');

%% max(avg)/norm

norm = sqrt(ave_r^2 + ave_g^2 +ave_b^2);

new_r = maxa*nred/norm;
new_g = maxa*ngreen/norm;
new_b = maxa*nblue/norm;

final = cat(3, new_r, new_g, new_b);
figure(6); imshow(final);
saveas(6,'GW_norm.png');
