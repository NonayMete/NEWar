function saveData(data, file)

fileID = fopen(file, 'w');
fprintf(fileID, '%f\t%f\t%f\t%f\n', data);
fprintf('%f\t%f\t%f\t%f\n', data);
fclose(fileID);