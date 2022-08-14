timetorques=horzcat(timetheta(:,1),Q);
PVTQ=[];
for cts=1:3%%%
    PVTQ=horzcat(PVTQ,Q(:,cts),dQ(:,cts));
end
FFTPVT=horzcat(pvt,PVTQ);

FFTS1Q=[];
for cts=1:3%%%
    FFTS1Q=horzcat(FFTS1Q,Q(:,cts));
end
FFTS1=horzcat(timetheta(:,2:4),FFTS1Q);