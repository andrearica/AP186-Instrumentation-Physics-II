load C:\Users\AndreaRica\Documents\Andy\AP186\A13\final.mat

figure(1)
scatter(Oe,Ohue,'r','filled');hold on;
scatter(Ae,Ahue,'g','filled');
scatter(Be,Bhue,'y','filled');
legend('Orange','Green Apple','Banana');
xlim([min([Ae Be Oe]),max([Ae Be Oe])]);
ylim([min([Ahue Bhue Ohue]),max([Ahue Bhue Ohue])]);
ylabel("Hue");
xlabel("Eccentricity");
%%
M = 3; %fruit classes, pdf for every fruit
N = length(Ae); %data points

%initializations
Pl = [1/M; 1/M; 1/M];
Sig = ones(2,2,3);Sig(2,1,:)=0;
mu = [mean(Ae), mean(Ahue);
    mean(Be), mean(Bhue);
    mean(Oe), mean(Ohue)];
%%
p = zeros(3,20);
x = [Ae; Ahue]';
y = [Be; Bhue]';
z = [Oe; Ohue]';
%%
thresh = 0.0001;
for i=1:2
    for l=1:length(Ae)
        p(1,l) = exp(-0.5*(x(l,:)-mu(1,:))*inv(Sig(:,:,1))*(x(l,:)-mu(1,:))')/((2*pi)*sqrt(det(Sig(:,:,1))));
    end

    for l=1:length(Ae)
        p(2,l) = exp(-0.5*(y(l,:)-mu(2,:))*inv(Sig(:,:,2))*(y(l,:)-mu(2,:))')/((2*pi)*sqrt(det(Sig(:,:,2))));
    end

    for l=1:length(Ae)
        p(3,l) = exp(-0.5*(z(l,:)-mu(3,:))*inv(Sig(:,:,3))*(z(l,:)-mu(3,:))')/((2*pi)*sqrt(det(Sig(:,:,3))));
    end


    P = (Pl.*p)./sum(Pl.*p,2);


    Pl = sum(P,2)./length(x);

    mu = [sum(x(:,1).*P(1,:)')/sum(P(1,:)), sum(x(:,2).*P(1,:)')/sum(P(1,:));
    sum(y(:,1).*P(2,:)')/sum(P(2,:)), sum(y(:,2).*P(2,:)')/sum(P(2,:));
    sum(z(:,1).*P(3,:)')/sum(P(3,:)), sum(z(:,2).*P(3,:)')/sum(P(3,:))];

    Sig = zeros(2,2,3);
    for j = 1:N
        temp1 = P(1,j)*((x(j,:)-mu(1,:))'*(x(j,:)-mu(1,:)))
        Sig(:,:,1) = Sig(:,:,1)+temp1;
        Sig(:,:,1) = Sig(:,:,1)/sum(P(1,:));
        
        temp2 = P(2,j)*((y(j,:)-mu(2,:))'*(y(j,:)-mu(2,:)))
        Sig(:,:,2) = Sig(:,:,2)+temp2;
        Sig(:,:,2) = Sig(:,:,2)/sum(P(2,:));
        
        temp3 = P(3,j)*((z(j,:)-mu(3,:))'*(z(j,:)-mu(3,:)))
        Sig(:,:,3) = Sig(:,:,3)+temp3;
        Sig(:,:,3) = Sig(:,:,3)/sum(P(3,:));
    end
end
%%
xcor = linspace(min([Ae Be Oe]),max([Ae Be Oe]),100);
ycor = linspace(min([Ahue Bhue Ohue]),max([Ahue Bhue Ohue]),100);
[X, Y] = meshgrid(xcor,ycor);
X1 = reshape(X,1,10000);
Y1 = reshape(Y,1,10000);
XY1 = [X1; Y1];


Z1 = zeros(1,10000);Z2 = zeros(1,10000);Z3 = zeros(1,10000);
for l = 1:10000
    Z1(l) = exp(-0.5*(XY1(:,l)'-mu(1,:))*inv(Sig(:,:,1))*(XY1(:,l)'-mu(1,:))')/((2*pi)*sqrt(det(Sig(:,:,1))));
    Z2(l) = exp(-0.5*(XY1(:,l)'-mu(2,:))*inv(Sig(:,:,2))*(XY1(:,l)'-mu(2,:))')/((2*pi)*sqrt(det(Sig(:,:,2))));
    Z3(l) = exp(-0.5*(XY1(:,l)'-mu(3,:))*inv(Sig(:,:,3))*(XY1(:,l)'-mu(3,:))')/((2*pi)*sqrt(det(Sig(:,:,3))));
end
Z1 = (Z1-min(Z1))/(max(Z1)-min(Z1));Z2 = (Z2-min(Z2))/(max(Z2)-min(Z2));Z3 = (Z3-min(Z3))/(max(Z3)-min(Z3));
Z1 = reshape(Z1,[100,100]);Z2 = reshape(Z2,[100,100]);Z3 = reshape(Z3,[100,100]);


figure(2);
surf(X,Y,Z1,'EdgeColor','None');hold on
surf(X,Y,Z2,'EdgeColor','None');
surf(X,Y,Z3,'EdgeColor','None');
grid off
set(gca,'color',[0.239 0.149 0.659]);
ylabel("Hue");
xlabel("Eccentricity");
colorbar();

figure(3);
surf(X,Y,Z1,'EdgeColor','None');hold on
surf(X,Y,Z2,'EdgeColor','None');
surf(X,Y,Z3,'EdgeColor','None');
s1 = scatter3(Oe,Ohue,ones(1,N),'r','filled');
s2 = scatter3(Ae,Ahue,ones(1,N),'g','filled');
s3 = scatter3(Be,Bhue,ones(1,N),'y','filled');
legend('','','','Orange','Green Apple','Banana');
s1.MarkerFaceAlpha = 0.6;
s2.MarkerFaceAlpha = 0.6;
s3.MarkerFaceAlpha = 0.6;
colorbar();
grid off
set(gca,'color',[0.239 0.149 0.659]);
ylabel("Hue");
xlabel("Eccentricity");
