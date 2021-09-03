clc; clear; close all; fclose('all');

%%
path = 'Datafiles/';
exp = 698;
%%
scans = [68, 120, 122:134, 136:153];
datamat = [];
for ii=1:length(scans)
    datfilename = [path,sprintf('HB3_exp%04d_scan%04d.dat',exp,scans(ii))];
    disp(['read file: ', datfilename]);
    datStruct = loadHB3datfile(datfilename); 
    x = getfield(datStruct, 'k');
    y = getfield(datStruct, 'e');
    intensity = getfield(datStruct, 'detector');
    mcu = getfield(datStruct, 'mcu');
    err = sqrt(intensity);
    
    intensity = intensity./mcu*60; % normalized to per 60 mcu
    err = err./mcu*60;
    singlefile = [x,y,intensity,err];
    datamat = [datamat;singlefile];
end
%% rebine data, if given bin width is smaller than original one, original one will be used.
dl = 0.1;
dE = 0.5;
[ X_axis, Y_axis, data_new , err_new] = Rebin_2D_witherror( datamat(:,1), datamat(:,2), datamat(:,3), datamat(:,4), dl, dE );

%% plot 
% imagesc(data_new);
% set(gca, 'ydir', 'normal');
% caxis([5,80]);
[X,Y] = meshgrid(X_axis+dl/2,Y_axis');
surf(X,Y,data_new,'edgecolor', 'none');
title('Mesh scan at [0 K 0] at T = 1.438 K');
view(2);
colormap jet;
h = colorbar;
h.Label.String = 'Intensity (cts/60mcu)';
caxis([5,80]);
zlabel('Intensity (cts/60 mcu)');
xlim([1.2,3.5]);
xlabel('[0 K 0] (r.l.u.)');
ylim([-1.5,30]);
ylabel('Energy (meV)');



