function data = combinedata( path, exp, scans )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

data = [];
for ii=1:length(scans)
    datfilename = [path,sprintf('HB3_exp%04d_scan%04d.dat',exp,scans(ii))];
    datStruct = loadHB3datfile(datfilename);
    singledata = [datStruct.e, datStruct.detector./datStruct.mcu*60, sqrt(datStruct.detector)./datStruct.mcu*60];
    data = [data;singledata];
end
data = sortrows(data,1);

end

