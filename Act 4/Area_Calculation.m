nx = 100;
x = linspace(-1,1,nx);
[X,Y] = meshgrid(x);


r = sqrt(X.^2 + Y.^2);
circle = zeros(nx);
circle(find(r<=0.5))=1;
% figure(1);imshow(circle)

square = zeros(100);
square(find(abs(X)<0.5&abs(Y)<0.5))=1;
% figure(2);imshow(square);

circle2 = zeros(100);
circle2(find(r<=0.5))=1;
circle2(find(r<=0.20))=0;
% figure(3);imshow(circle2)

triangle = zeros(nx);
xc = [10 50 90];
yc = [80 20 80];
mask = poly2mask(xc, yc, nx,nx);
triangle(mask)=1;
% figure(4);imshow(triangle);

diamond = zeros(nx);
xc = [10 50 90];
yc = [50 10 50];
mask = poly2mask(xc, yc, nx,nx);
diamond(mask)=1;
xc = [10 50 90];
yc = [50 90 50];
mask = poly2mask(xc, yc, nx,nx);
diamond(mask)=1;
% figure(5);imshow(diamond);

squircle = zeros(nx);
squircle(find(r<=0.5))=1;
squircle(find(abs(X)<0.5&Y<0.5&Y>0))=1;
% figure(6);imshow(squircle);
%%
Ec = edge(circle2,'canny');
El = edge(circle2,'LoG');
Er = edge(circle2,'roberts');
%%
J = imread('C:\Users\AndreaRica\Documents\Andy\AP 186\A4\gmaps_upvtc_bin.PNG');
J = im2bw(J);
Jc = edge(J,'roberts');

%%
[y,x]=find(Jc==1);
c = [y,x];
centroid = [floor((max(c(:,1))+min(c(:,1)))/2) floor((max(c(:,2))+min(c(:,2)))/2) ];
newx = x-centroid(2);
newy = y-centroid(1);

r = sqrt(newx.^2+newy.^2);
th = atan2(newy,newx)*(180/pi);

[newth, thorder]=sort(th);
newr = r(thorder,:);
newx1 = x(thorder,:);
newy1 = y(thorder,:);

sum=0;
[a,b]=size(newx1);
for i =1:a-1
    sum = sum + ((newx1(i)*newy1(i+1))-(newy1(i)*newx1(i+1)));
end    

sum = (sum + (newx1(a-1))*newy1(1) - (newy1(a-1)*newx1(1)))/2;
disp(sum)
