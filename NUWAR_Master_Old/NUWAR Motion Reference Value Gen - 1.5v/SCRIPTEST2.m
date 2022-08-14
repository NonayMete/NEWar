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

a=size(timetheta);
a=a(1);
x=timetheta(:,2:4);
corrective=[];
for i=2:1:(a-1)
    fiveptcorrection = (x((i-1),:)+8*x(i,:)-x((i+1),:))/6;
    corrective=[corrective;fiveptcorrection];
end

final=[x(1,:);corrective;x(a,:)];
final=horzcat(timetheta(:,1),final);
b=size(FFTS1);
b=b(1);
y=FFTS1;
corrective=[];
for i=2:1:(a-1)
    fiveptcorrectionfft= (y((i-1),:)+8*y(i,:)-y((i+1),:))/6; 
    correctivefft=[correctivefft;fiveptcorrectionfft];
end

finalfft=[y(1,:);correctivefft,y(b,:)];