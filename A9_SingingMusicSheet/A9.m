%%
sheet = imread('lvnr1.jpg');

sh = rgb2gray(sheet);
sh = sh<190;
sh = bwareaopen(sh,5);
figure(1);
imshow(sh);
saveas(1,"bin.png");

%% extract lines
l_str = strel('line',50,0);
l_str1 = strel('line',100,0);

l_sh = imerode(sh,l_str);
l_sh = imdilate(l_sh,l_str1);
l_sh = imerode(l_sh,l_str1);
l_sh = imerode(l_sh,l_str);
l_sh = imdilate(l_sh,l_str1);
% s_sh = imerode(s_sh,s_str);
% s_sh = imerode(s_sh,s_str);
l_sh = imdilate(l_sh,l_str1);
l_sh = imdilate(l_sh,l_str);
l_sh = imerode(l_sh,l_str1);
l_sh = imerode(l_sh,l_str1);

% sort lines
Lin=bwlabel(l_sh')';
mL = max(Lin,[],'all');

[mnL,c] = find(Lin==1);
[mxL,c] = find(Lin==mL);
l_sh = l_sh(mnL-40:mxL+40,:);
sh = sh(mnL-40:mxL+40,:);
Lin = bwlabel(l_sh')';

figure(2)
imshow(l_sh);
% measure spaces, save locations
n_dist = [];
s_dist = [];
l_dist = [];

L = zeros(1,mL); %y-locations line

for i=1:mL
    [r,c] = find(Lin==i);
    L(i) = min(r);
    m1 = mod(i,5);
    if (m1~=1 && i~=1)
        m2 = mod (i,5);
%         if m2~=1
            n_dist = [n_dist;(L(i)-L(i-1))];
%         else            
%             s_dist = [s_dist;(L(i)-L(i-1))];
%         end
    elseif (i~=1 && m1==1)
        l_dist = [l_dist;(L(i)-L(i-1))];
    end
end

n_spc = mean(n_dist)/4;
s_spc = mean(s_dist);
l_spc = mean(l_dist)/2;

%% extract notes

str = strel([1;1]);
str1 = strel([1 1]);
str2 = strel('disk', 1);


n_sh = imerode(sh,str);
% n_sh = imdilate(n_sh,str1);
n_sh = bwareaopen(n_sh,10);
% n_sh = imclose(n_sh,str1);
n_sh = imdilate(n_sh,str1);
n_sh = imerode(n_sh,str);
% n_sh = imdilate(n_sh,str1);

n_sh(481:482,215:216) = 1;
n_sh(488:489,209:210) = 1;
n_sh(258:259,958:960) = 1;
n_sh(266:267,960:961) = 1;
n_sh(89,113:115) = 1;
n_sh(297,113:115) = 1;
n_sh = bwareaopen(n_sh,10);
figure(3)
imshow(n_sh);
saveas(3,"notes.png");
%% Cut into three lines

%Lines
figure(5);
sizeLin = size(Lin);
line1=Lin(1:L(5)+l_spc,:);
line1 = bwlabel(line1')';
imshow(line1);
line2=Lin(L(5)+l_spc:L(10)+l_spc,:);
line2 = bwlabel(line2')';
subplot(6,8,[9,10,11,12,13,14,15,16]);imshow(line2);
line3=Lin(L(10)+l_spc:sizeLin(1),:);
line3 = bwlabel(line3')';
subplot(6,8,[17,18,19,20,21,22,23,24]);imshow(line3);

Lin_loc = zeros(3,5);
for i=1:5
    [r1,~] = find(line1==i);
    [r2,~] = find(line2==i);
    [r3,~] = find(line3==i);
    Lin_loc(1,i) = min(r1);
    Lin_loc(2,i) = min(r2);
    Lin_loc(3,i) = min(r3);
end


nline1=n_sh(1:L(5)+l_spc,:);
nline1 = bwlabel(nline1);
subplot(6,8,[1,2,3,4,5,6,7,8]);imshow(nline1);
nline2=n_sh(L(5)+l_spc:L(10)+l_spc,:);
nline2 = bwlabel(nline2);
subplot(6,8,[9,10,11,12,13,14,15,16]);imshow(nline2);
nline3=n_sh(L(10)+l_spc:sizeLin(1),:);
nline3 = bwlabel(nline3);
subplot(6,8,[17,18,19,20,21,22,23,24]);imshow(nline3);
%% 

tanan = bwlabel(n_sh);
qrtr_u = (tanan == 12);
qrtr_d = (tanan == 15);
eighth_d = (tanan == 13);
eighth_u = (tanan == 18);
half_u = (tanan == 20);
half_d = (tanan == 50);
sharp = (tanan == 23);
eight_r = (tanan==101);
full = (tanan==100);
quarter = (tanan==59);
quarter1 = (tanan==24);
items = cat(3,qrtr_u,qrtr_d,eighth_u,eighth_d,half_u,half_d,full,eight_r,sharp);

%%
% figure();imshow(nline1);        
[nline1,t1] = extract(nline1,items);
figure(6);imshow(nline1);        

% figure();imshow(nline2);        
[nline2,t2] = extract(nline2,items);
figure(7);imshow(nline2);        

% figure();imshow(nline3);        
[nline3,t3] = extract(nline3,items);
figure(8);imshow(nline3);     

finT = [t1,t2,t3];
%%
%line1
str = strel('disk',2);
str1 = strel('line',4,0);
str2 = strel('line',5,90);
str4 = strel('rectangle', [2,2]);

nh_line1 = imdilate(nline1,str2);
nh_line1 = imerode(nh_line1,str1);
nh_line1 = imclose(nh_line1, str4);
% imshow(nh_line1);

nh_line1 = bwlabel(nh_line1);
note_CA = regionprops(nh_line1,'Area');
idx = find([note_CA.Area]>120 | [note_CA.Area]<60);
idx1 = find([note_CA.Area]<120);

nh_line1_tone = nh_line1;
for i=idx
    nh_line1_tone(nh_line1==i) = 0;
end

% nh_line1_bars = nh_line1;
% for i=idx1
%     nh_line1_bars(nh_line1==i) = 0;
% end

nh_line1_tone(nh_line1_tone>0)=1;
nh_line1_tone = bwlabel(nh_line1_tone);
note_tones_c1 = regionprops(nh_line1_tone,'Centroid');
figure();imshow(nh_line1_tone);    
% nh_line1_bars(nh_line1_bars>0)=1;
% nh_line1_bars = bwlabel(nh_line1_bars);
% note_bars_e1 = regionprops(nh_line1_bars,'Extrema');
% figure();imshow(nh_line1_bars);    


%line2
str1 = strel('line',4,0);
str2 = strel('line',5,90);
str4 = strel('rectangle', [2,2]);

nh_line2 = imdilate(nline2,str2);
nh_line2 = imerode(nh_line2,str1);
nh_line2 = imclose(nh_line2, str4);
% figure();imshow(nline2);

nh_line2 = bwlabel(nh_line2);
note_CA2 = regionprops(nh_line2,'Area');
idx = find([note_CA2.Area]>160 | [note_CA2.Area]<60);
idx1 = find([note_CA2.Area]<160);

nh_line2_tone = nh_line2;
for i=idx
    nh_line2_tone(nh_line2==i) = 0;
end

% nh_line2_bars = nh_line2;
% for i=idx1
%     nh_line2_bars(nh_line2==i) = 0;
% end

nh_line2_tone(nh_line2_tone>0)=1;
nh_line2_tone = bwlabel(nh_line2_tone);
note_tones_c2 = regionprops(nh_line2_tone,'Centroid');
figure();imshow(nh_line2_tone);    
% nh_line2_bars(nh_line2_bars>0)=1;
% nh_line2_bars = bwlabel(nh_line2_bars);
% note_bars_e2 = regionprops(nh_line2_bars,'Extrema');
% figure();imshow(nh_line2_bars);    


%line3
str1 = strel('line',4,0);
str2 = strel('line',5,90);
str4 = strel('rectangle', [2,2]);

% figure();imshow(nline3);
nh_line3 = imdilate(nline3,str2);
nh_line3 = imerode(nh_line3,str1);
nh_line3 = imclose(nh_line3, str4);
% figure();imshow(nh_line3);

nh_line3 = bwlabel(nh_line3);
note_CA3 = regionprops(nh_line3,'Area');
idx = find([note_CA3.Area]>160 | [note_CA3.Area]<60);
idx1 = find([note_CA3.Area]<160);

nh_line3_tone = nh_line3;
for i=idx
    nh_line3_tone(nh_line3==i) = 0;
end

% nh_line3_bars = nh_line3;
% for i=idx1
%     nh_line3_bars(nh_line3==i) = 0;
% end

nh_line3_tone(nh_line3_tone>0)=1;
nh_line3_tone = bwlabel(nh_line3_tone);
note_tones_c3 = regionprops(nh_line3_tone,'Centroid');
figure();imshow(nh_line3_tone);   

% nh_line3_bars(nh_line3_bars>0)=1;
% nh_line3_bars = bwlabel(nh_line3_bars);
% note_bars_e3 = regionprops(nh_line3_bars,'Extrema');
% figure();imshow(nh_line3_bars);    


%% extract centroids
m1 = max(nh_line1_tone,[],'all');
m2 = max(nh_line2_tone,[],'all');
m3 = max(nh_line3_tone,[],'all');
mN = m1+m2+m3;
rs = zeros(1,mN);
cs = zeros(1,mN);
for i=1:mN
%         c1 = cat(1,note_tones_c1.Centroid);
%         c2 = cat(1,note_tones_c2.Centroid);
%         c3 = cat(1,note_tones_c3.Centroid);
    if i<=m1
%         rs(i) = c1(i,2);
        [row,col] = find(nh_line1_tone==i);
    elseif i<=(m1+m2)
%         rs(i) = c2(i-m1,2);
        [row,col] = find(nh_line2_tone==i-m1);
    elseif i<=mN
%         rs(i) = c3(i-m1-m2,2);
        [row,col] = find(nh_line3_tone==i-m1-m2);
    end
    rs(i) = ((max(row)-min(row))/2)+min(row);
end
%%
imshow(nh_line1_tone)
hold(imgca,'on')
plot(imgca,c1(:,1), c1(:,2), 'r*')
hold(imgca,'off')
%%
so = [];
notes = [];
for i=1:mN
    if i==20
            so=[so,note(G4,finT(i))];disp(i);disp(finT(i));
    elseif i<=m1 %Linloc1
        if (rs(i)<(Lin_loc(1,1)+n_spc) && rs(i)>(Lin_loc(1,1)-n_spc))
            so=[so,note(F5,finT(i))]; notes=[notes,"F5"];
        elseif (rs(i)<(Lin_loc(1,2)-n_spc) && rs(i)>(Lin_loc(1,1)+n_spc))
            so=[so,note(E5,finT(i))];notes=[notes,"E5"];
        elseif (rs(i)<(Lin_loc(1,2)+n_spc) && rs(i)>(Lin_loc(1,2)-n_spc))
            so=[so,note(D5,finT(i))];notes=[notes,"D5"];
        elseif (rs(i)<(Lin_loc(1,3)-n_spc) && rs(i)>(Lin_loc(1,2)+n_spc))
            so=[so,note(C5,finT(i))];notes=[notes,"C5"];
        elseif (rs(i)<(Lin_loc(1,3)+n_spc) && rs(i)>(Lin_loc(1,3)-n_spc))
            so=[so,note(B4,finT(i))];notes=[notes,"B4"];
        elseif (rs(i)<(Lin_loc(1,4)-n_spc) && rs(i)>(Lin_loc(1,3)+n_spc))
            so=[so,note(A4,finT(i))];notes=[notes,"A4"];
            disp(rs(i));
        elseif (rs(i)<(Lin_loc(1,4)+n_spc) && rs(i)>(Lin_loc(1,4)-n_spc))
            so=[so,note(G4,finT(i))];notes=[notes,"G4"];
            disp(rs(i));
        elseif (rs(i)<(Lin_loc(1,5)-n_spc) && rs(i)>(Lin_loc(1,4)+n_spc))
            so=[so,note(F4,finT(i))];notes=[notes,"F4"];
        elseif (rs(i)<(Lin_loc(1,5)+n_spc) && rs(i)>(Lin_loc(1,5)-n_spc))
            so=[so,note(E4,finT(i))];notes=[notes,"E4"];
        elseif (rs(i)<(Lin_loc(1,5)+(n_spc*3)) && rs(i)>(Lin_loc(1,5)+n_spc))
            so=[so,note(D4,finT(i))];notes=[notes,"D4"];
        elseif (rs(i)<(Lin_loc(1,5)+(n_spc*5)) && rs(i)>(Lin_loc(1,5)+(n_spc*3)))
            so=[so,note(C4,finT(i))];notes=[notes,"C4"];
        elseif (rs(i)<(Lin_loc(1,5)+(n_spc*7)) && rs(i)>(Lin_loc(1,5)+(n_spc*5)))
            so=[so,note(B3,finT(i))];notes=[notes,"B3"];
        end
    
    elseif i<=(m1+m2) %Linloc1
        
        
        if (rs(i)<(Lin_loc(2,1)+n_spc) && rs(i)>(Lin_loc(2,1)-n_spc))
            so=[so,note(F5,finT(i))]; notes=[notes,"F5"];
        elseif (rs(i)<(Lin_loc(2,2)-n_spc) && rs(i)>(Lin_loc(2,1)+n_spc))
            so=[so,note(E5,finT(i))];notes=[notes,"E5"];
        elseif (rs(i)<(Lin_loc(2,2)+n_spc) && rs(i)>(Lin_loc(2,2)-n_spc))
            so=[so,note(D5,finT(i))];notes=[notes,"D5"];
        elseif (rs(i)<(Lin_loc(2,3)-n_spc) && rs(i)>(Lin_loc(2,2)+n_spc))
            so=[so,note(C5,finT(i))];notes=[notes,"C5"];
        elseif (rs(i)<(Lin_loc(2,3)+n_spc) && rs(i)>(Lin_loc(2,3)-n_spc))
            so=[so,note(B4,finT(i))];notes=[notes,"B4"];
        elseif (rs(i)<(Lin_loc(2,4)-n_spc) && rs(i)>(Lin_loc(2,3)+n_spc))
            so=[so,note(A4,finT(i))];notes=[notes,"A4"];
            disp(rs(i));
        elseif (rs(i)<(Lin_loc(2,4)+n_spc) && rs(i)>(Lin_loc(2,4)-n_spc))
            so=[so,note(G4,finT(i))];notes=[notes,"G4"];
            disp(rs(i));
        elseif (rs(i)<(Lin_loc(2,5)-n_spc) && rs(i)>(Lin_loc(2,4)+n_spc))
            so=[so,note(F4,finT(i))];notes=[notes,"F4"];
        elseif (rs(i)<(Lin_loc(2,5)+n_spc) && rs(i)>(Lin_loc(2,5)-n_spc))
            so=[so,note(E4,finT(i))];notes=[notes,"E4"];
        elseif (rs(i)<(Lin_loc(2,5)+(n_spc*3)) && rs(i)>(Lin_loc(2,5)+n_spc))
            so=[so,note(D4,finT(i))];notes=[notes,"D4"];
        elseif (rs(i)<(Lin_loc(2,5)+(n_spc*5)) && rs(i)>(Lin_loc(2,5)+(n_spc*3)))
            so=[so,note(C4,finT(i))];notes=[notes,"C4"];
        elseif (rs(i)<(Lin_loc(2,5)+(n_spc*7)) && rs(i)>(Lin_loc(2,5)+(n_spc*5)))
            so=[so,note(B3,finT(i))];notes=[notes,"B3"];
        end
    
    elseif i<=mN %Linloc1
        if (rs(i)<(Lin_loc(3,1)+n_spc) && rs(i)>(Lin_loc(3,1)-n_spc))
            so=[so,note(F5,finT(i))]; notes=[notes,"F5"];
        elseif (rs(i)<(Lin_loc(3,2)-n_spc) && rs(i)>(Lin_loc(3,1)+n_spc))
            so=[so,note(E5,finT(i))];notes=[notes,"E5"];
        elseif (rs(i)<(Lin_loc(3,2)+n_spc) && rs(i)>(Lin_loc(3,2)-n_spc))
            so=[so,note(D5,finT(i))];notes=[notes,"D5"];
        elseif (rs(i)<(Lin_loc(3,3)-n_spc) && rs(i)>(Lin_loc(3,2)+n_spc))
            so=[so,note(C5,finT(i))];notes=[notes,"C5"];
        elseif (rs(i)<(Lin_loc(3,3)+n_spc) && rs(i)>(Lin_loc(3,3)-n_spc))
            so=[so,note(B4,finT(i))];notes=[notes,"B4"];
        elseif (rs(i)<(Lin_loc(3,4)-n_spc) && rs(i)>(Lin_loc(3,3)+n_spc))
            so=[so,note(A4,finT(i))];notes=[notes,"A4"];
            disp(rs(i));
        elseif (rs(i)<(Lin_loc(3,4)+n_spc) && rs(i)>(Lin_loc(3,4)-n_spc))
            so=[so,note(G4,finT(i))];notes=[notes,"G4"];
            disp(rs(i));
        elseif (rs(i)<(Lin_loc(3,5)-n_spc) && rs(i)>(Lin_loc(3,4)+n_spc))
            so=[so,note(F4,finT(i))];notes=[notes,"F4"];
        elseif (rs(i)<(Lin_loc(3,5)+n_spc) && rs(i)>(Lin_loc(3,5)-n_spc))
            so=[so,note(E4,finT(i))];notes=[notes,"E4"];
        elseif (rs(i)<(Lin_loc(3,5)+(n_spc*3)) && rs(i)>(Lin_loc(3,5)+n_spc))
            so=[so,note(D4,finT(i))];notes=[notes,"D4"];
        elseif (rs(i)<(Lin_loc(3,5)+(n_spc*5)) && rs(i)>(Lin_loc(3,5)+(n_spc*3)))
            so=[so,note(C4,finT(i))];notes=[notes,"C4"];
        elseif (rs(i)<(Lin_loc(3,5)+(n_spc*7)) && rs(i)>(Lin_loc(3,5)+(n_spc*5)))
            so=[so,note(B3,finT(i))];notes=[notes,"B3"];
        end
    end
end

%%
B3 = 246.94;
C4 = 261.63;
D4 = 293.66;
E4 = 329.63;
F4 = 349.23; 
G4 = 392.00;
A4 = 440.00;
B4 = 493.88;
C5 = 523.25;
D5 = 587.33;
E5 = 659.25;
F5 = 698.46;

function [s] = note(f,time)
    t = [0:1/9000:time];
    s = [sin(2*pi*f*t),repmat(0,1,100)]; 
% s = [note(C4,t), note(D4,t), note(E4,t), note(C4,t), note(D4,t), note(G4,t1), note(F4,t1), note(E4,t), note(D4,t1), note(E4,t), note(C4,t), note(D4,t), note(E4,t1)];
% sound(s);
end
%%
function [area,n] = correlate(Og,In)
    rain = imcomplement(Og);
    A = imcomplement(In);
    Frain = fft2(rain);
    FA = fft2(A);
    FI = FA.*conj(Frain);
    I = fft2(FI);
    I = fftshift(mat2gray(abs(I)));
    I = I>0.70;
    
    a = regionprops(I,'Area');
    n = max(bwlabel(I),[],'all');
    area = mean([a.Area]);
%     if (n>1 && area<30)
%         figure();imshow(I);
%     end
%   
    
%     disp(area)
    
end

%%
% items = cat(3,eighth_u,eighth_d,qrtr_u,qrtr_d,half_u,half_d,full,eight_r,sharp);
function [t] = timing(index)
    if (index == 3 || index==4 )
        t = 0.325;
    elseif (index == 1 || index==2)
        t = 0.65;
    elseif (index == 5 || index == 6)
        t = 1.3;
    elseif index == 7
        t = 2.6;
     else
         t = [];
    end
end

%% extract notes
function [n,t] = extract(nline,items)
mn1 = max(nline,[],'all');
t=[];
for i = 1:mn1
    stats = regionprops(nline,'Area','Centroid');
    [sn,~] = size(nline);
    a = [stats.Area];
    [c,~] = stats.Centroid;
    if a(i)<15
        nline(nline==i) = i-1;
    end
    old = 1000;
    for j = 1:9
        stat = regionprops(items(:,:,j),'Centroid');
        [sl,~] = size(items(:,:,j));
        cr = floor(stat.Centroid);
        up = cr(2)-sn/2;
        down = cr(2)+sn/2;
        if up<1
            check = items(1:down-up,:,j);
        elseif down>sl
            check = items(up-(down-sl):sl,:,j);
        else 
            check = items(up:down,:,j);
        end
        [sl,~] = size(check);
        if sl>sn
            check = check(1:sn,:);
        end
    [areaCorr,n] = correlate(nline==i,check);
        if (areaCorr<25 && (n==4 || n==1))
            if areaCorr<old
                if n>1
                    ft=repmat(0.325,1,n);
                else
                    ft = timing(j);
                end
                old = areaCorr;
            end
        end
    end
    if (j==9 && old == 1000)
        nline(nline==i) = 0;
    elseif (j==9 && old~=1000)
        t = [t,ft];
    end
%     disp(t)

end
n = bwlabel(nline);
    for i = 1:max(n,[],'all');
    fs = regionprops(n,'Area');
    as = [fs.Area];
    if as(i)<15
        n(n==i) = i-1;
    end
    end
end
