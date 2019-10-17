myfunc = makefuns;
%%
square = zeros(9,9);
square(3:7,3:7) =1;
myfunc.plot_this(square);
saveas(gcf,'square.jpg');
%%
triangle = ones(9,8);
triangle(1,:)=0;
triangle(2,:)=0;
triangle(3,:)=0;
triangle(7,:)=0;
triangle(8,:)=0;
triangle(9,:)=0;
triangle(4,1:5)=0;
triangle(4,7:8)=0;
triangle(5,1:3)=0;
triangle(5,7:8)=0;
triangle(6,1:2)=0;
triangle(6,7:8)=0;
myfunc.plot_this(triangle);
saveas(gcf,'triangle.jpg');
%%
hollow = ones(14,14);
hollow(1:2,:) = 0;
hollow(13:14,:) = 0;
hollow(:,13:14) = 0;
hollow(:,1:2) = 0;
hollow(5:10,5:10) = 0;
myfunc.plot_this(hollow);
saveas(gcf,'hollow.jpg');
%%
plus = ones(11,11);
plus(1:5,1:5)=0;
plus(7:12,1:5)=0;
plus(1:5,7:12)=0;
plus(7:12,7:12)=0;
plus(1:3,:)=0;
plus(9:11,:)=0;
plus(:,1:3)=0;
plus(:,9:11)=0;
myfunc.plot_this(plus);
saveas(gcf,'plus.jpg');

%% Application
prefix = 'C_00';
Fext = '.jpg';
B = zeros(20,7);
for j=1:7
    I = imread(['C:\Users\AndreaRica\Documents\Andy\AP 186\A8_\Circles00\' prefix num2str(j) Fext]);
    %histogram(I,256);

    % figure()
    BW = zeros(size(I));
    BW(find(I>205))=1;
    % imshow(BW);
    Fet='.png';
    imwrite(BW,[prefix num2str(j) Fet]);
%     se = strel('disk',1);
%     n_BW = imclose(BW,se);
    se = strel('disk',6);
    n_BW = imopen(BW,se);
    
    L = bwlabeln(n_BW);
    figure() 
    imshow(n_BW);


    maxL = max(L,[],'all');

    for i=1:maxL
        blob = L==i;
%         figure();
%         imshow(blob);
        blobthis = edge(blob,'canny');
        B(i,j) = myfunc.area(blobthis);
    end
    imwrite(n_BW,[prefix num2str(j) Fext]);
end


indexes = find(B~=0);
count = size(indexes);
Areas = zeros(count(1),1);
for ind = 1:count(1)
    Areas(ind) = B(indexes(ind));
end

M = mean(Areas);
S = std(Areas);


%% Cancer
prefix = 'Ca_0';
for j =2:3
    I = imread(['C:\Users\AndreaRica\Documents\Andy\AP 186\A8_\Cancer\' prefix num2str(j) Fext]);
    %histogram(I,256);

    % figure()
    BW = zeros(size(I));
    BW(find(I>205))=1;
    % imshow(BW);
     
%     se = strel('disk',1);
%     n_BW = imclose(BW,se);
    se = strel('disk',6);
    n_BW = imopen(BW,se);
    se = strel('disk',3);
    n_BW = imerode(n_BW,se);
    
    L = bwlabeln(n_BW);
    figure() 
    imshow(n_BW);
    Fet='.png';
    imwrite(n_BW,[prefix num2str(j) Fet]);

    maxL = max(L,[],'all');

    for i=1:maxL
        blob = L==i;
%         figure();
%         imshow(blob);
        blobthis = edge(blob,'canny');
        B(i,j) = myfunc.area(blobthis);
        if B(i,j) > M+S
            n_BW(find(L==i)) = 0.5;
        end
    end
    
    
    figure()
    imshow(n_BW);
    imwrite(n_BW,[prefix num2str(j) Fext]);
end
%%
function funs = makefuns
  funs.plot_this=@plot_this;
  funs.area=@area;
end

%%

function s1_dilated = plot_this(F)
    square = [[0 1 1];[0 1 1]; [0 0 0]];
    SE1 = strel(square);
    rect12 = [[0 1 0];[0 1 0]; [0 0 0]];
    SE2 = strel(rect12);
    rect21 = [[0 0 0];[0 1 1]; [0 0 0]];
    SE3 = strel(rect21);
    cross = [[0 1 0];[1 1 1]; [0 1 0]];
    SE4 = strel(cross);
    diag = [[0 0 1];[0 1 0]; [0 0 0]];
    SE5 = strel(diag);
    
    figure();
    subplot(5,4,1);
    imshow(F);
    title("image");
    subplot(5,4,2);
    imshow(SE1.Neighborhood);
    title("struc elem" );
    % subplot(2,2,2);
    % imshow(SE1);
    subplot(5,4,3);
    s1_dilated = imdilate(F,SE1);
    imshow(s1_dilated);
    title("Dilate" );
    subplot(5,4,4);
    s1_erode = imerode(F,SE1);
    imshow(s1_erode);
    title("Erode");

    
    subplot(5,4,6);
    imshow(SE2.Neighborhood);
    subplot(5,4,7);
    s2_dilated = imdilate(F,SE2);
    imshow(s2_dilated);
    
    subplot(5,4,8);
    s2_erode = imerode(F,SE2);
    imshow(s2_erode);

    subplot(5,4,10);
    imshow(SE3.Neighborhood);
    subplot(5,4,11);
    s3_dilated = imdilate(F,SE3);
    imshow(s3_dilated);
    subplot(5,4,12);
    s3_erode = imerode(F,SE3);
    imshow(s3_erode);
    
    subplot(5,4,14);
    imshow(SE4.Neighborhood);
    subplot(5,4,15);
    s4_dilated = imdilate(F,SE4);
    imshow(s4_dilated);
    subplot(5,4,16);
    s4_erode = imerode(F,SE4);
    imshow(s4_erode);
    
    
    subplot(5,4,18);
    imshow(SE5.Neighborhood);
    box on;
    subplot(5,4,19);
    s5_dilated = imdilate(F,SE5);
    imshow(s5_dilated);
    subplot(5,4,20);
    s5_erode = imerode(F,SE5);
    imshow(s5_erode);
    
end

%%

function [B] = area(b)
    [row1,col1] = find(b);
    c = [row1,col1];
    c = fliplr(c);
    d = zeros(size(c));
    centroid = [floor((max(c(:,1))+min(c(:,1)))/2) floor((max(c(:,2))+min(c(:,2)))/2) ];

    %
    %
    %
    [rc,cc] = size(c);
    for i=1:rc
        d(i,1) = c(i,1) - centroid(1);
        d(i,2) = c(i,2) - centroid(2);
    end

    [row2,col2] = find(d(:,1)>=0);
    e = [row2,col2];

    [row3,col3] = find(d(:,1)<0);
    f = [row3,col3];


    e = [e(:,1) zeros(size(row2))];
    for i = 1:size(row2)
        e(i,2) = atan(d(e(i),2)/d(e(i),1))*(180/pi);
    end
    %
    [Y,I] = sort(e(:,2));
    e = e(I,:);
    e1 = zeros(size(e));
    [re,ce] = size(e);
    for i = 1:re
        e1(i,1) = c(e(i,1),1);
        e1(i,2) = c(e(i,1),2);
    end



    f = [f(:,1) zeros(size(row3))];
    for i = 1:size(row3)
        f(i,2) = atan(d(f(i),2)/d(f(i),1))*(180/pi);
    end

    [X,J] = sort(f(:,2));
    f = f(J,:);
    f1 = zeros(size(f));
    [rf,cf] = size(f);
    for i = 1:rf
        f1(i,1) = c(f(i,1),1);
        f1(i,2) = c(f(i,1),2);
    end
    
    value = size(e1(:,1))+size(f1(:,1));
    final = zeros(value(1),2);
    final(1:size(e1(:,1)), :) = e1;
    final(size(e1(:,1))+1:size(final),:) = f1;

    [rfinal,cfinal] = size(final);
    B = 0;
    for i = 1:(rfinal-1)
        B = B + (final(i,1))*(final(i+1,2)) - (final(i,2)*final(i+1,1));
    end

    B = (B + (final(rfinal,1))*final(1,2) - (final(rfinal,2)*final(1,1)))/2;
end
