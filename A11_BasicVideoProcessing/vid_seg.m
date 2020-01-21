%% Thresholding
N1 = '0';
prefix = 'FF1 ';
Fext = '.jpg';
%%
% 
for i = 1:9
    I = imread(['D:\Experimental Data\Video Tracking\FF1\' prefix N1 num2str(i) Fext]);
    [count,cells] = imhist(I,256);
%     plot(cells,count);

    BW = zeros(size(I));
    BW(find(I>20))=1;
    BW = im2bw(BW);
%     figure()
%     imshow(BW);
    imwrite(BW,['D:\Experimental Data\Video Tracking\FF1\seg\' prefix N1 num2str(i) Fext]);
end;
%% Zeros
J = imread(['D:\Experimental Data\Video Tracking\FF1\seg\FF1 099.jpg']);
[y0, x0] = ndgrid(1:size(J, 1), 1:size(J, 2));
c0 = mean([x0(logical(J)), y0(logical(J))]);
cx0=c0(1);
cy0=718-c0(2);

pos = zeros([99,3]);
%% centroid
N1='00';
for i=1:9;
    J = imread(['D:\Experimental Data\Video Tracking\FF1\seg\' prefix N1 num2str(i) Fext]);
    [y, x] = ndgrid(1:size(J, 1), 1:size(J, 2));
    c = mean([x(logical(J)), y(logical(J))]);  
    cx = c(1);
    cy = 718-c(2);
    
    
    pos(i,3) = i/30;
    pos(i,1) = (cx-cx0)/0.5479;
    pos(i,2) = (cy-cy0)/0.5479;
end;

%%
