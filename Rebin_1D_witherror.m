function [ Y_axis, data_new , err_new] = Rebin_1D_witherror( Y, data, err, dY )
% Rebin_2D : rebin 3D data of [Y, data, err] and bin width dX, dY.
%   Detailed explanation goes here
%   input: 
%   Y    : horizental and vertical grid matrix, same size of data
%   data    : data matrix
%   err     : error matrix
%   dY  : bin size for horizental and vertical axis
%   output:
%   Y_axis :  row and col vector, from min to max value of X and Y
%   with step dX and dY
%   data_new and err_new       :  rebined data matrix with size of
%   length(Y_axis)*1
% 1) the errorbar are recalculated,
% 2) if dY is smaller than the input space of Y, use input
% one, data and error will not been binned.

tol = 1e-6; % tol for equality precission.

Y_min = min(Y(:));
Y_max = max(Y(:));

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
data_new = zeros(length(Y_new)-1,1);
err_new = zeros(length(Y_new)-1,1);

for jj = 1:length(Y_new)-1
    
    idy = find((abs(Y_new(jj)-Y)<tol | Y_new(jj)<Y) & Y<Y_new(jj+1));
    if isempty(idy)
        data_new(jj) = NaN;
        err_new(jj) = NaN;
    else
        data_new(jj) = sum(data(id))/numel(data(id));
        err_new(jj) = sqrt(sum(err(id).^2))/numel(err(id));
    end
    fprintf('Rebin 1D completed: %d/%d\n',ii,length(Y_new)-1);
end    

end

