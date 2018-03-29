function [ c ] = spline2_fit( x, y, z, d, knots_x, knots_y, lambda )
%lambda --- регуляризующий параметр, например 0.005
if nargin < 7
	lambda = 0;
end

x = x(:);
y = y(:);
z = z(:);

xmin = knots_x(1);
xmax = knots_x(end);
tx = [repmat(xmin, [1, d]), knots_x, repmat(xmax, [1, d])];

ymin = knots_y(1);
ymax = knots_y(end);
ty = [repmat(ymin, [1, d]), knots_y, repmat(ymax, [1, d])];

ncoeff_x = numel(knots_x) + d - 1;
ncoeff_y = numel(knots_y) + d - 1;
B = zeros(numel(x), ncoeff_x*ncoeff_y);

bspline_x = zeros(numel(x), ncoeff_x);
bspline_y = zeros(numel(x), ncoeff_y);
parfor j = 1 : ncoeff_x
	bspline_x(:, j) = bspline(x, j, d, tx, d);
end
parfor k = 1 : ncoeff_y
	bspline_y(:, k) = bspline(y, k, d, ty, d);
end

for j = 1 : ncoeff_x
    for k = 1 : ncoeff_y
        B(:, (j - 1)*ncoeff_y + k) = bspline_x(:, j).*bspline_y(:, k);
    end
end

%(B'*B)\(B'*z);
%c = B\z; 
if lambda ~= 0
	c = (B'*B + lambda*eye(ncoeff_x*ncoeff_y))\(B'*z);
else
	c = B\z; 
end

