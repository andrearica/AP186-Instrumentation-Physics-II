y = [0.233436188 0.229676431 0.214089848 0.184959652 0.138618915 0.078715165 0.019775398];
t = [0.733333333 0.766666667 0.8 0.833333333 0.866666667 0.9 0.933333333];
x = [0.007275344 0.036230548 0.066616618 0.09802022 0.130801032 0.162627687 0.190399199];
t = t-t(1);

xp = polyfit(t,x,2);
yp = polyfit(t,y,2);
trendx = polyval(xp,t);
trendy = polyval(yp,t);
figure(1);
plot(t,x,'o-'); hold on;
plot(t,trendx);
legend('x vs t', 'fit');
ylabel("x-position (m)");
xlabel("Time (s)");
title("Projectile Motion (x)");
figure(2);
plot(t,y,'o-'); hold on;
plot(t,trendy,'--');
legend('y vs t', 'fit');
ylabel("y-position (m)");
xlabel("Time (s)");
title("Projectile Motion (y)");
%%
y = [0.262498491 0.253956299 0.230078345 0.190793737 0.141219824 0.074837933 0.02];
t = [0.6 0.633333333 0.666666667 0.7 0.733333333 0.766666667 0.8];
t = t-t(1);

yp = polyfit(t,y,2);
trendy = polyval(yp,t);
figure(3);
plot(t,y,'o-'); hold on;
plot(t,trendy,'--');
legend('y vs t', 'fit');
ylabel("y-position (m)");
xlabel("Time (s)");
title("Free Fall");