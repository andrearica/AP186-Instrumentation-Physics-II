%% Free Fall
%% Image Segmentation
prefix = 'FF1 0';
Fext = '.jpg';
 for j=10:99
    I = imread(['C:\Users\AndreaRica\Documents\Andy\AP 186\A10\FF1\' prefix num2str(j) Fext]);
    I = rgb2gray(I);
%     histogram(I,256);

%     figure()
    BW = zeros(size(I));
    BW(find(I>10))=1;
    se = strel('disk',2);
    n_BW = imclose(BW,se);
    
    imwrite(n_BW,['C:\Users\AndreaRica\Documents\Andy\AP 186\A10\FF1_seg\' prefix num2str(j) Fext]);
 end

%% Calibration
Z = imread('C:\Users\AndreaRica\Documents\Andy\AP 186\A10\FF1_seg\FF1 025.png');
Z = imopen(Z,se);
[y, x] = ndgrid(1:size(Z, 1), 1:size(Z, 2));
centroid = mean([x(logical(Z)), y(logical(Z))]);

cy0 = 720-(centroid(2)+37.5);

%% Positions
Fext='.png';
pos = zeros([7,3]);
for j = 1:25
    Z = imread(['C:\Users\AndreaRica\Documents\Andy\AP 186\A10\FF1_seg\FF1 0' num2str(j) Fext]);
    Z = imopen(Z,se);
    [y, x] = ndgrid(1:size(Z, 1), 1:size(Z, 2));
    centroid = mean([x(logical(Z)), y(logical(Z))]);
    cx = centroid(1);
    cy = centroid(2);
    
    
    pos(j,2) = (720-cy)-cy0;
    pos(j,3) = (j-1)/30;
end

pos(:,1)= pos(:,1)/1875;
pos(:,2)= pos(:,2)/1875;

%%
h = pos(:,2);
t = pos(:,3);

%% Projectile
%% Image Segmentation
prefix = 'P1 0';
Fext = '.jpg';
 for j=1:9
    I = imread(['C:\Users\AndreaRica\Documents\Andy\AP 186\A10\P1\' prefix num2str(j) Fext]);
    I = rgb2gray(I);
%     histogram(I,256);

%     figure()
    BW = zeros(size(I));
    BW(find(I>10))=1;
    se = strel('disk',2);
    n_BW = imclose(BW,se);
    se = strel('disk',20);
    n_BW = imopen(n_BW,se);
    
    imwrite(n_BW,['C:\Users\AndreaRica\Documents\Andy\AP 186\A10\P1_seg\' prefix num2str(j) Fext]);
 end

%% Calibration
Z = imread('C:\Users\AndreaRica\Documents\Andy\AP 186\A10\P1_seg\P1 22.png');
[y, x] = ndgrid(1:size(Z, 1), 1:size(Z, 2));
centroid = mean([x(logical(Z)), y(logical(Z))]);
cx0 = centroid(1)-48.5;


Z = imread('C:\Users\AndreaRica\Documents\Andy\AP 186\A10\P1_seg\P1 29.png');
[y, x] = ndgrid(1:size(Z, 1), 1:size(Z, 2));
centroid = mean([x(logical(Z)), y(logical(Z))]);
cy0 = 720-(centroid(2)+48.5);
%% Positions
Fext='.png';
pos = zeros([7,3]);
for j = 22:29
    Z = imread(['C:\Users\AndreaRica\Documents\Andy\AP 186\A10\P1_seg\P1 ' num2str(j) Fext]);
    Z = imopen(Z,se);
    [y, x] = ndgrid(1:size(Z, 1), 1:size(Z, 2));
    centroid = mean([x(logical(Z)), y(logical(Z))]);
    cx = centroid(1);
    cy = centroid(2);
    
    pos(j-21,1) = cx-cx0;
    pos(j-21,2) = (720-cy)-cy0;
    pos(j-21,3) = (j-1)/30;
end

pos(:,1)= pos(:,1)/2425;
pos(:,2)= pos(:,2)/2425;
