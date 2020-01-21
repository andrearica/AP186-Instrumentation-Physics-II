t = Val(:,1);
y = Val(:,2);
x = Val(:,3);
%%

xx = polyfit(tx,x,2);
t1 = linspace(min(tx),max(tx));
x1 = polyval (xx,t1);
figure
plot(tx,x,".");
hold on
plot(t1,x1);

eqx = [num2str(xx(1)) 'x^2+' num2str(xx(2)) 'x' num2str(xx(3))];
legend('x vs t',eqx);
title ("x vs t");
xlabel("t(s)");
ylabel("x(m)");
hold off

%%
yy = polyfit(t,y,2);
y1 = polyval (yy,t1);
figure
plot(t,y,".");
hold on
plot(t1,y1,'--');

eq = [num2str(yy(1)) 'y^2+' num2str(yy(2)) 'y+' num2str(yy(3))];
legend('y vs t',eq);
title ("y vs t");
xlabel("t(s)");
ylabel("y(m)");
hold off