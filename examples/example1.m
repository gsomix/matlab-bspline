%% setup
close all
degree = 3;

errAbs = 0.05;
err = @(s, a, b) a + (b-a).*rand(s);
f = @(x) exp(-x.^2);
f_err = @(x) f(x) + err(size(x), -errAbs/2, errAbs/2);

xMin = -1;
xMax = 1;
nx = 200;
nknots = 4;

x = linspace(xMin, xMax, nx)';
y = f(x);
y_err = f_err(x);
knots = linspace(xMin, xMax, nknots);

%% fit
c = spline_fit(x, y_err, degree, knots);
y_fit = spline_eval(x, c, degree, knots);

%% plot
bspline_show(x, degree, knots);
figure; plot(x, y, x, y_err, x, y_fit);
figure; plot(x, y - y_fit);

%% stat
aver = sum(y)/nx;
rrmse = sqrt(sum((y - y_fit).^2)/nx) / aver * 100