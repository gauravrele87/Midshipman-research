%This is a test for a single erry shipand finding the power before and after the ship passes using the data
% that is already in the memory using the ferrydata

load ferrydata.mat
i = 151957;
buffer1 = input('input a number','s');
if(length(buffer1));i=str2num(buffer1);end

[infile1,infile2,infile3,error] = findfile(matlabday(i),xcen(i));


cpyfindareashp(infile1,infile2,infile3,xcen(i),xsig(i),erf(i),4);
