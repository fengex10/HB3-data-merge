function data = hb3combinedata2( path, exp, scans ,dY)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dataraw = [];
for ii=1:length(scans)
    datfilename = [path,sprintf('HB3_exp%04d_scan%04d.dat',exp,scans(ii))];
    datStruct = loadHB3datfile(datfilename);
    singledata = [datStruct.e, datStruct.detector./datStruct.mcu*60, sqrt(datStruct.detector)./datStruct.mcu*60];
    dataraw = [dataraw;singledata];
end
%data = sortrows(data,1);

%% rebin
tol = 1e-6; % tol for equality precission.
Y = dataraw(:,1);
Int = dataraw(:,2);
err = dataraw(:,3);

Y_min = min(Y);
Y_max = max(Y);

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
%idy = []
for jj = 1:length(Y_new)-1
    
    idy = find((abs(Y_new(jj)-Y)<tol | Y_new(jj)<Y) & Y<Y_new(jj+1));
    if isempty(idy)
        data_new(jj) = NaN;
        err_new(jj) = NaN;
    else
        data_new(jj) = sum(Int(idy))/numel(Int(idy));
        err_new(jj) = sqrt(sum(err(idy).^2))/numel(err(idy));
    end
    %fprintf('Rebin 1D completed: %d/%d\n',ii,length(Y_new)-1);
end    

data = [Y_axis, data_new, err_new];

end

