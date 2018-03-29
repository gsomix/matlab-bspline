%% setup
close all
degree = 3;

errAbs = 0.05;
err = @(s, a, b) a + (b-a).*rand(s);
f = @(x, y) cos(10*(x.^2+y)).*sin(10*(x+y.^2));
f_err = @(x, y) f(x, y) + err(size(x), -errAbs/2, errAbs/2);

xMin = -1;
xMax = 1;
yMin = -1;
yMax = 1;
nx = 100;
ny = 100;
nknots_x = 64;
nknots_y = 64;

x = linspace(xMin, xMax, nx)';
y = linspace(yMin, yMax, ny)';
[x, y] = meshgrid(x, y);
x = reshape(x, [numel(x) 1]);
y = reshape(y, [numel(y) 1]);

z = f(x, y);
z_err = f_err(x, y);
knots_x = linspace(xMin, xMax, nknots_x);
knots_y = linspace(yMin, yMax, nknots_y);

%% fit
c = spline2_fit(x, y, z_err, degree, knots_x, knots_y);
z_fit = spline2_eval(x, y, c, degree, knots_x, knots_y);

%% plot
x = reshape(x, [nx, ny]);
y = reshape(y, [nx, ny]);
z = reshape(z, [nx, ny]);
z_err = reshape(z_err, [nx, ny]);
z_fit = reshape(z_fit, [nx, ny]);

figure; imagesc(z_err);
figure; imagesc(z_fit);
figure; imagesc(z - z_fit);

%% stat
aver = sum(sum(z))/nx/ny;
rrmse = sqrt(    sum(sum(    (z - z_fit).^2    ))/nx/ny    ) / aver * 100