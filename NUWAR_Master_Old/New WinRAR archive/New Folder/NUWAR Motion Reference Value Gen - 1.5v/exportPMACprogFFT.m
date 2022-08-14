function data = exportPMACprogFFT(FFT, dest)

fileID = fopen(dest, 'w');
FFT = FFT';
data = fprintf(fileID,'X%.4f:%.4f Y%.4f:%.4f Z%.4f:%.4f\n', FFT(1:6,:));
fclose(fileID);
