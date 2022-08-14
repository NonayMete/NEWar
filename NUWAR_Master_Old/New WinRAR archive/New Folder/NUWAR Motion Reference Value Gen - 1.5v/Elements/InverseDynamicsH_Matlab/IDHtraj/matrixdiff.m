%[diffdata] = matrixdiff(data, step, samp, diffpoints)
%
% This function is designed for numerical differentation. Input data should be in the form of column vectors.
% If data is a matrix, matrix diff will calculate derivatives for each column. This is done using matrix operations
% and is very efficient. This function can use either a 3 or 5 point numerical differentiation scheme.
% This is selected using the diffpoints input parameter.

% Inputs:
%			data - input data to be differentiated.
%			step - timeperiod between sample points
%			samp - number of sample points
%			diffpoints	- Differentiation scheme to use. (3 or 5)

% Outputs:
% diffdata: first derivative of data.
% 
% Author: Ben Hawkey 2000


function [diffdata]=matrixdiff(data, step, samp, diffpoints)


width = size(data,2);

switch diffpoints
   
case 3
   
   diffdata(1,:)=zeros(1,width);
   
   diffdata(2:samp-1,:)=1/step.*(-1/2.*data(1:(samp-2),:)+1/2.*data(3:samp,:));
   
   diffdata(samp,:)= zeros(1,width);
   
case 5
   
   diffdata(1,:)=zeros(1,width);
   
   diffdata(2,:)=1/step.*(-1/2.*data(1,:)+1/2.*data(3,:));
   
   diffdata(3:(samp-2),:)=1/(12*step).*(data(1:(samp-4),:)-8.*data(2:(samp-3),:)+8.*data(4:(samp-1),:)-data(5:samp,:));
   
   diffdata(samp-1,:)=1/step.*(-1/2.*data(samp-2,:)+1/2.*data(samp,:)); 
   
   diffdata(samp,:)= zeros(1,width);
   
otherwise
   disp('Number of differentiation points "diffpoints" must equal either 3 or 5')
end

   


