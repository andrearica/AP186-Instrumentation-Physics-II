clear
load final.mat

figure, scatter(Oe,Ohue,'r');hold on;
scatter(Ae,Ahue,'g');
scatter(Be,Bhue,'y');
legend('Orange','Green Apple','Banana');
ylabel("Hue");
xlabel("Eccentricity");

%%
d = [ones(1,length(Ae)),-ones(1,length(Ae))];

n = 0.001;
eps = 1e-2;
%%
w = rand(3,1);
xab = [ones(1,2*length(Ae));Ae,Be;Ahue,Bhue];
for j = 1:250
    z = [];
    for i =1:length(d)
        a = dot(xab(:,i),w);
        z = [z;g(a)];
        dw = n*(d(i)-z(i)).*xab(:,i);
        w = w+dw;
    end
    res = (sum((d'-z).^2,'all'));
%     disp(res)
    if res<eps
%         disp(j)
        break
    end
end

C = -w(1); A = w(2); B = w(3);
m = -A/B; b = C/B;

disp(w);
disp (m);
disp(b);

x = linspace(0,1,100);
yab = b+m*x;
%%
w = rand(3,1);
xao = [ones(1,2*length(Ae));Oe,Ae;Ohue,Ahue];
for j = 1:250
    z = [];
    for i =1:length(d)
        a = dot(xao(:,i),w);
        z = [z;g(a)];
        dw = n*(d(i)-z(i)).*xao(:,i);
        w = w+dw;
    end
    res = (sum((d'-z).^2,'all'));
%     disp(res)
    if res<eps
%         disp(j)
        break
    end
end

C = -w(1); A = w(2); B = w(3);
m = -A/B; b = C/B;

disp(w);
disp (m);
disp(b);

yao = b+m*x;
%%
w = rand(3,1);
xob = [ones(1,2*length(Ae));Be,Oe;Bhue,Ohue];
for j = 1:250
    z = [];
    for i =1:length(d)
        a = dot(xob(:,i),w);
        z = [z;g(a)];
        dw = n*(d(i)-z(i)).*xob(:,i);
        w = w+dw;
    end
    res = (sum((d'-z).^2,'all'));
%     disp(res)
    if res<eps
%         disp(j)
        break
    end
end

C = -w(1); A = w(2); B = w(3);
m = -A/B; b = C/B;

disp(w);
disp (m);
disp(b);

x1 = linspace(0.65,1,50);
yob = b+m*x1;
hold on;
plot(x,yab,x,yao,x1,yob);
%%
figure(2), scatter(Oe,Ohue,'r');hold on;
scatter(Ae,Ahue,'g');
plot(x,yao);
legend('Orange','Green Apple','Decision Line');
ylabel("Hue");
xlabel("Eccentricity");
saveas(2,"OA.png");

figure(3), scatter(Oe,Ohue,'r');hold on;
scatter(Be,Bhue,'y');
plot(x1,yob);
legend('Orange','Banana','Decision Line');
ylabel("Hue");
xlabel("Eccentricity");
saveas(3,"OB.png");

figure(4), scatter(Ae,Ahue,'g');hold on;
scatter(Be,Bhue,'y');
plot(x,yab);
legend('Green Apple','Banana','Decision Line');
ylabel("Hue");
xlabel("Eccentricity");
saveas(4,"AB.png");
%%
function [z] = g(a)
    if a>= 0
        z = 1;
    else
        z = -1;
    end
end
