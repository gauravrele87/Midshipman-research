infile='2srtc110700.shg';
infid=fopen(infile,'r'); % opens the file with parameter read (r) or write(w)
npt=fread(infid,1,'int32'); % integer 32 bit reading one point
matlabday=fread(infid,npt,'float64');  %npt is dimension of array, date 
year2000=fread(infid,npt,'float32'); %same as above
waterday=fread(infid,npt','float32');
erf=fread(infid,npt,'float32');
xcen=fread(infid,npt,'float32');
xsig=fread(infid,npt,'float32');
ycen=fread(infid,npt,'float32');
ybkg=fread(infid,npt,'float32');
pcen=fread(infid,npt,'float32');
ptot=fread(infid,npt,'float32');
s2n=fread(infid,npt,'float32'); %signal to noise ratio
r2=fread(infid,npt,'float32'); %statistical measure of the fit
hour=mod(waterday,1);
arlft=fread(infid,npt,'float32');
arRt=fread(infid,npt,'float32');
wdl=fread(infid,npt,'float32');
wdr=fread(infid,npt,'float32');
hour = mod(waterday,1);


test1=(erf==0); 
buffer1=input('Number of days 02 ','s')

%plotting all the points with error function zero with xsig and ycen
subplot(2,2,1)
plot(xsig(test1),ycen(test1),'.');
xlabel('half-width');
ylabel('peak height');
ylim([0 0.05]);
test1 =xsig~=0
buffer1=input('Number of days 03  ','s')
%checking for the ships with similar xsigs ie similar boats like ferries 
test2=test1&xsig<=15&xsig>=5;
subplot(2,2,3);
plot(xsig(test2),ycen(test2),'.');
xlabel('half-width');
ylabel('peak height');
title('Ferry ships?');
xlim([0 40]);

buffer1=input('Number of days 04 ','s')
subplot(2,2,2)
plot(hour(test1),ycen(test1),'.');
title('ships during the whole day')
ylabel('peakheight');
xlabel('Time in days');
ylim([0 0.05]);
hold on
buffer1=input('Number of days  ','s');

subplot(2,2,4)
plot(hour(test2),ycen(test2),'.');
xlabel('time in one day');
ylabel('peak height');
title('Ferry times');


%test a : H< outside line 0.027*(1-w/28)
% test b : H < insideline 0.018*(1-w/15) 
% c  width less than 5
% d night time 5.25<x<  12.5


testA = test1&(ycen < 0.027*(1-xsig/28)); %below highest (tankers)line from y=0.027 to zero for xsig 28
testB = test1&(ycen <0.018*(1-xsig/15));%below (ferry,small ships) (middle)line from y=0.018 to zero for xsig 15
testC = test1&(xsig<5);
testD = test1&(hour<0.25|hour> 0.525);

testAB = test1&(ycen < 0.027*(1-xsig/28))&(ycen>0.018*(1-xsig/15));

testBCbar = testB&(~testC)

testBCbarD = testBCbar&testD;
