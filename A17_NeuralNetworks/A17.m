%% Initialization
clear
load final.mat 
X = [ones(size(Ae(1:10))) ones(size(Ae(1:10))) ones(size(Ae(1:10)));Ae(1:10) Be(1:10) Oe(1:10);Ahue(1:10) Bhue(1:10) Ohue(1:10)]';
Y = [zeros(size(Ae(1:10))) 0.5*ones(size(Ae(1:10))) ones(size(Ae(1:10)))]';

lr = 0.01; %Learning Rate
maxIters = 1000000; %Max Iterations
%%
rng(1)
W = rand(3,2); %Weights
W1 = rand(2,1);



for m = 1:maxIters
   a = dotprod(X,W);
   z = sigmoid(a);
   ak = dotprod(z,W1);
   yk = sigmoid(ak);
   
   diffk = yk-Y;
   errqk = dsigmoid(ak);
   sigmak = diffk.*errqk;
   
   diffj = dotprod(sigmak,W1');
   errqj = dsigmoid(a);
   sigmaj = diffj.*errqj;

   errork = dotprod(z',sigmak);
   errorj = dotprod(X',sigmaj);
   
   W = W - lr*errorj;
   W1 = W1 - lr*errork;
   E = sum(diffk.^2)/2;
end

%% Test
test = [ones(size(Ae(11:20))) ones(size(Ae(11:20))) ones(size(Ae(11:20)));Ae(11:20) Be(11:20) Oe(11:20);Ahue(11:20) Bhue(11:20) Ohue(11:20)]';
[N D] = size(test);

test_out = [];
for i = 1:N
    aT = dotprod(test(i,:),W);
    zT = sigmoid(aT);
    akT = dotprod(zT,W1);
    ykT = sigmoid(akT)
   
    
    test_out = [test_out,ykT];
end

%%
figure(1);
plot(Y);hold on
plot(test_out);
hold off;
legend('Expected', 'Test');
% title("800K Iterations");
% saveas(1,'Sine800K.png');
%%
xcor = linspace(min([Ae Be Oe]),max([Ae Be Oe]),1000);
ycor = linspace(min([Ahue Bhue Ohue]),max([Ahue Bhue Ohue]),1000);
[X, Y] = meshgrid(xcor,ycor);
X1 = reshape(X,1,1000000);
Y1 = reshape(Y,1,1000000);
XY1 = [ones(1,1000000);X1; Y1]';

contourplot = [];
for i = 1:1000000
    aT = dotprod(XY1(i,:),W);
    zT = sigmoid(aT);
    akT = dotprod(zT,W1);
    ykT = sigmoid(akT);
    if ykT <= 0.4
        ykT =0;
    elseif ykT >= 0.6
        ykT = 1;
    else 
        ykT = 0.5;
    end
    
    contourplot = [contourplot,ykT];
end
%%
contourplot = reshape(contourplot,[1000,1000]);
figure(2);
contourf(X,Y,contourplot,'EdgeColor','None');hold on
grid off
% set(gca,'color',[0.239 0.149 0.659]);
ylabel("Hue");
xlabel("Eccentricity");

%%
s1 = scatter(Oe(11:20),Ohue(11:20),'r','filled');
s2 = scatter(Ae(11:20),Ahue(11:20),'g','filled');
s3 = scatter(Be(11:20),Bhue(11:20),'y','filled');
legend('Classification','Oranges','Green Apple','Banana');
s1.MarkerFaceAlpha = 0.6;
s2.MarkerFaceAlpha = 0.6;
s3.MarkerFaceAlpha = 0.6;
%% Functions
function g = sigmoid(a)
g = 1.0 ./ (1.0 + exp(-2*a));
end

function gprime = dsigmoid(a)
gprime = 2*sigmoid(a).*(1-sigmoid(a));
end

function g = tanhh(a)
g = (exp(a) - exp(-a))./(exp(a) + exp(-a))
end

function gprime = dtanh(a)
gprime = 1 + (tanhh(a)).^2
end

function check(x, W, mode)
if mode == 'og'
    plot(x, x - (x.^3)/factorial(3) + (x.^5)/factorial(5) - (x.^7)/factorial(7) + (x.^9)/factorial(9) - (x.^11)/factorial(11))
elseif mode == 'w'
    plot(x, (x.^0)*W(1)+(x.^1)*W(2)+(x.^2)*W(3)+(x.^3)*W(4)+(x.^4)*W(5)+(x.^5)*W(6)+(x.^6)*W(7)+(x.^7)*W(8)+(x.^8)*W(9)+(x.^9)*W(10)+(x.^10)*W(11)+(x.^11)*W(12));
end
end

function out = scaledata(in, maxv, minv)
out = in - min(in,[],'all');
out = ((out)/(max(in,[],'all') - min(in,[],'all')))*(maxv-minv);
out = out + minv;
end
