function saveData(data, file)

data=data';
fileID = fopen(file, 'w');
fprintf(fileID, '%f\t%f\t%f\t%f\n', data);
%fprintf('%f\t%f\t%f\t%f\n', data);
fclose(fileID);