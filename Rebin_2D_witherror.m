function [ X_axis, Y_axis, data_new , err_new] = Rebin_2D_witherror( X, Y, data, err, dX, dY )
% Rebin_2D : rebin 3D data of [X, Y, data, err] and bin width dX, dY.
%   Detailed explanation goes here
%   input: 
%   X, Y    : horizental and vertical grid matrix, same size of data
%   data    : data matrix
%   err     : error matrix
%   dX, dY  : bin size for horizental and vertical axis
%   output:
%   X_axis, Y_axis :  row and col vector, from min to max value of X and Y
%   with step dX and dY
%   data_new and err_new       :  rebined data matrix with size of
%   length(Y_axis)*length(X_axis)
% 1) the errorbar are recalculated,
% 2) if dX and dY are smaller than the input space of X and Y, use input
% one, data and error will not been binned.

tol = 1e-6; % tol for equality precission.
X_min = min(X(:));
X_max = max(X(:));
Y_min = min(Y(:));
Y_max = max(Y(:));

AX = sort(unique(X(:)));
dXmin = min(abs(AX(2:end)-AX(1:end-1))); % smallest space of input X
if dX<dXmin || abs(dX-dXmin)<tol % case for not to bin
    dX = dXmin;
    X_new = [X_min:dX:X_max, X_max+dX];
    X_axis = X_new(1:end-1);
else
    X_new = [X_min:dX:X_max];
    X_new = [X_new, X_new(end)+dX];
    X_axis = X_new(1:end-1)+dX/2;
end

AY = sort(unique(Y(:)));
dYmin = min(abs(AY(2:end)-AY(1:end-1))); % smallest space of input Y
if dY<dYmin || abs(dY-dYmin)<tol
    dY = dYmin;
    Y_new = [Y_min:dY:Y_max, Y_max+dY];
    Y_axis = Y_new(1:end-1);
else
    Y_new = [Y_min:dY:Y_max];
    Y_new = [Y_new, Y_new(end)+dY];
    Y_axis = Y_new(1:end-1)+dY/2;
end
Y_axis = Y_axis';

%%
data_new = zeros(length(Y_new)-1,length(X_new)-1);
err_new = zeros(length(Y_new)-1,length(X_new)-1);
for ii = 1:length(X_new)-1
    % equal need define precission!!
    idx = find((abs(X_new(ii)-X)<tol | X_new(ii)<X) & X<X_new(ii+1));
    for jj = 1:length(Y_new)-1
        idy = find((abs(Y_new(jj)-Y)<tol | Y_new(jj)<Y) & Y<Y_new(jj+1));
        if isnan(idx) 
            fprintf('X=%f; Y=%f', X_new(ii), Y_new(jj));
        end
        id = intersect(idx,idy);
        if isempty(id)
            data_new(jj,ii) = NaN;
            err_new(jj,ii) = NaN;
        else
            data_new(jj,ii) = sum(sum(data(id)))/numel(data(id));
            err_new(jj,ii) = sqrt(sum(sum(err(id).^2)))/numel(err(id));
        end
    end    
    fprintf('Rebin 2D completed: %d/%d\n',ii,length(X_new)-1);
end

% X_axis = X_new(1:end-1)+dX/2;
% Y_axis = Y_new(1:end-1)+dY/2;

end

