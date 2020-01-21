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
X = [Ae Oe; Ahue Ohue]';
Z = [ones(1,20) -ones(1,20)]';

H = (X*X').*(Z*Z');
f = -ones(40,1);
A = -eye(40);
a = zeros(40,1);
B = [[Z]'; [zeros(39,40)]];
b = zeros(40,1);

alph = quadprog(H+eye(40)+0.001,f,A,a,B,b);

w = (alph.*Z)'*x;
wo = (1/Z(1))-w'*X(1);
