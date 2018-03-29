%% setup
close all
degree = 3;

errAbs = 0.05;
err = @(s, a, b) a + (b-a).*rand(s);
f = @(x, y) cos(10*(x.^2+y)).*sin(10*(x+y.^2));
fx = @(x, y)    10*cos( 10*(x.^2 + y) ).*cos( 10*(x + y.^2) ) - ...
             20*x.*sin( 10*(x.^2 + y) ).*sin( 10*(x + y.^2) );
fy = @(x, y) 20*y.*cos( 10*(x.^2 + y) ).*cos( 10*(x + y.^2) ) - ...
                10*sin( 10*(x.^2 + y) ).*sin( 10*(x + y.^2) );
            
fx_err = @(x, y) fx(x, y) + err(size(x), -errAbs/2, errAbs/2);
fy_err = @(x, y) fy(x, y) + err(size(x), -errAbs/2, errAbs/2);
            
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
zx = fx(x, y);
zy = fy(x, y);
zx_err = fx_err(x, y);
zy_err = fy_err(x, y);

knots_x = linspace(xMin, xMax, nknots_x);
knots_y = linspace(yMin, yMax, nknots_y);

%% fit
c = spline2_fit_der(x, y, zx_err, zy_err, degree, knots_x, knots_y);
[z_fit] = spline2_eval(x, y, c, degree, knots_x, knots_y);
[zx_fit, zy_fit] = spline2_eval_der(x, y, c, degree, knots_x, knots_y);

%% plot
x = reshape(x, [nx, ny]);
y = reshape(y, [nx, ny]);

z = reshape(z, [nx, ny]);
zx = reshape(zx, [nx, ny]);
zy = reshape(zy, [nx, ny]);

z_fit = reshape(z_fit, [nx, ny]);
zx_fit = reshape(zx_fit, [nx, ny]);
zy_fit = reshape(zy_fit, [nx, ny]);

zx_err = reshape(zx_err, [nx, ny]);
zy_err = reshape(zy_err, [nx, ny]);

f_delta = z - z_fit;
aver_level = (max(max(f_delta)) + min(min(f_delta)))/2;
figure; plot_fun2(x, y, z, 'Original function, $f(x, y)$', [], [], []);
figure; plot_fun2(x, y, z_fit, 'Fitted spline function, $f_{fit}(x,y)$', [], [], []);
figure; plot_fun2(x, y, (z - z_fit) - aver_level, 'Difference, $\Delta = f(x, y) - f_{fit}(x,y)$', [], [], []);

figure; plot_fun2(x, y, zx_err, 'Derivative $\frac{\partial f}{\partial x}$ + error', [], [], []);
figure; plot_fun2(x, y, zx_fit, 'Derivative of fitted function, $\frac{\partial f_{fit}}{\partial x}$', [], [], []);
figure; plot_fun2(x, y, zx - zx_fit, 'Difference, $\Delta_{x} = \frac{\partial f}{\partial x} - \frac{\partial f_{fit}}{\partial x}$', [], [], []);

figure; plot_fun2(x, y, zy_err, 'Derivative $\frac{\partial f}{\partial y}$ + error', [], [], []);
figure; plot_fun2(x, y, zy_fit, 'Derivative of fitted function, $\frac{\partial f_{fit}}{\partial y}$', [], [], []);
figure; plot_fun2(x, y, zy - zy_fit, 'Difference, $\Delta_{y} = \frac{\partial f}{\partial y} - \frac{\partial f_{fit}}{\partial xy}$', [], [], []);

%% stat
rmse_zx = sqrt(    sum(sum(  (zx-zx_fit).^2  ))/nx/ny    )
rmse_zy = sqrt(    sum(sum(  (zy-zy_fit).^2  ))/nx/ny    )