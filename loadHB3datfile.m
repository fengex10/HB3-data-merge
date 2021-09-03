function datStruct = loadHB3datfile( datfilename )
% read the *.dat file, and return structure type data
%   Syntax:  datStruct = loaddatfile('HB3A_exp0727_scan0055.dat')
%   Input :  datfilename, string, path can be include.
%   Output:  datStruct, structure type data, including below fields:
%

%   datStruct.def_x         : string, scan indenpentence, e.g. 'omega' scan
%   datStruct.def_y         : string, scan indenpentence, e.g. 'detector' scan
%   datStruct.XXX           : field of data column, XXX means the column name.
%% --------main function---------
fdat = fopen(datfilename, 'r');
datStruct = struct();
% check file opening
if fdat ==-1
    warning([datfilename,' cannot be open!']);
    return
end
%% ------------get info from headers-----------
while ~feof(fdat)
    tline = fgetl(fdat);
    if contains(tline, '# def_x')
        def_x = strsplit(tline);
        datStruct.def_x = def_x{end};                   % obtain the scan axis
    elseif contains(tline, '# def_y')
        def_y = strsplit(tline);
        datStruct.def_y = def_y{end};                   % obtain the scan axis
    end
end

frewind(fdat); % reset the read position indicator back to the begining of the file
%%
% --------get col names---------
while ~feof(fdat)
    tline = fgetl(fdat);
    if contains(tline,'# col_headers =') 
        tline = fgetl(fdat);
        break 
    end
end
colnames = strsplit(tline, {' ','.'});
colnames = colnames(2:end);
% ---------get data matrix --------
data = [];
n=0;
while ~feof(fdat)
    tline = fgetl(fdat);
    if strcmp(tline(1),'#')        
        continue 
    end
    n = n+1;
    tline = strsplit(tline);
    dataline = str2double(tline(2:end));
    data = [data;dataline];
end 
frewind(fdat)

% ----attribute columns to datStruct;
for ii=1:length(colnames)
    %issinlecol = cellfun(@(x)isequal(x, colnames{ii}), colnames);
    datStruct = setfield(datStruct, colnames{ii}, round(data(:,ii),3));
end

%%
fclose(fdat);
end