infile='2srtc110800.shg';
infid=fopen(infile,'r'); % opens the file with parameter read (r) or write(w)
npt=fread(infid,1,'int32'); % integer 32 bit reading one point
%npt=6191;
matlabday=fread(infid,npt,'float64');  %npt is dimension of array, date 
year2000=fread(infid,npt,'float32'); %same as above
waterday=fread(infid,npt,'float32');
erf=fread(infid,npt,'float32');
xcen=fread(infid,npt,'float32');
xsig=fread(infid,npt,'float32');
ycen=fread(infid,npt,'float32');
ybkg=fread(infid,npt,'float32');
pcen=fread(infid,npt,'float32');
ptot=fread(infid,npt,'float32');
s2n=fread(infid,npt,'float32'); %signal to noise ratio
r2=fread(infid,npt,'float32'); %statistical measure of the fit
arlft=fread(infid,npt,'float32');
arRt=fread(infid,npt,'float32');
wdl=fread(infid,npt,'float32');
wdr=fread(infid,npt,'float32');

hour = mod(waterday,1);

infiletff = strcat('/usr/local/data3/rtc/tff/2011/rtc110600.tff');
infidtf=fopen(infiletff,'r');  
npttf=fread(infidtf,1,'int32'); 
waterdaytf =fread(infidtf,npttf,'float32');
fcentf=fread(infidtf,npttf,'float32');
sigftf=fread(infidtf,npttf,'float32');
s2ntf=fread(infidtf,npttf,'float32');
pwrtf=fread(infidtf,npttf,'float32');
pdbtf=fread(infidtf,npttf,'float32');
erftf=fread(infidtf,npttf,'int32');


for i=1:npt
	erftff(i) = 0;
	if erftf(max(find(waterdaytf<waterday(i))))~=0
		erftff(i) =1 ; 
	end
end

test0 = (erftff==0).';
test01= (erf==0);
test1 = test0&test01;
num = sum(test1);
fprintf('Total number that passed test 1 is %d out of %d',num,npt);
testA = test1&(ycen < 0.027*(1-xsig/28)); %below highest (tankers)line from y=0.027 to zero for xsig 28
testB = test1&(ycen <0.018*(1-xsig/15));%below (ferry,small ships) (middle)line from y=0.018 to zero for xsig 15
testC = test1&(xsig<5);
testD = test1&(hour<0.25|hour> 0.525);

testAB = test1&(ycen < 0.027*(1-xsig/28))&(ycen>0.018*(1-xsig/15));

testBCbar = testB&(~testC)

testBCbarD = testBCbar&testD;


plot(arlft(test1),arRt(test1),'.');


figure(2);
test2= test1&xsig<=15&xsig>=5;

plot(arlft(test2),arRt(test2),'.');	



figure(3);
hist(arlft(test2)-arRt(test2),1000);



figure(4);
hist(arRt(test1),1000);
h1=findobj(gca,'Type','patch');
set(h1(1),'FaceColor','r')
hold on
hist(arlft(test1),1000);
h2=findobj(gca,'Type','patch');
set(h2(1),'FaceColor','g')
title('comparison between left and right, red=right, green=left');
hold off
buffer=input('press any key to continue','s');


figure(5);
test6= test1;
arlr= arlft(test6) - arRt(test6);
title('difference between left and the right area, left-right');

narlr = hist(arlr,-1000:50:1000);
buffer=input('press any key to continue','s');
title('histogram of arlr');

%asymmetric coefficient
asymm = narlr(22:41) - narlr(20:-1:1);
plot(asymm);
title('asymmetric coefficient');

buffer=input('press any key to continue','s');
plot(smooth(asymm));
hold on 
plot(0:20,zeros(21,1));
hold off
title('smooth version of asymm coeff');

medlft=median(arlft(test6));
medRt=median(arRt(test6));
meanlft=mean(arlft(test6));
meanRt=mean(arRt(test6));


fprintf('median left: %f \n median right: %f \n mean left: %f \n mean right: %f',medlft,medRt,meanlft,meanRt);


arlrComp=arlft-arRt;
test7=test6 & (arlrComp>(-1000)) & (arlrComp<(1000));

coeff= (arlft(test7) - arRt(test7))./(arlft(test7) + arRt(test7));

meanCoeff= mean(coeff)

mlmod=mod(matlabday,24);

test8= test7 & mlmod>4 & mlmod<14;

coeff1= (arlft(test8) - arRt(test8))./(arlft(test8) + arRt(test8));

meanCoeff1= mean(coeff1)


%wdl and wdr is equal to zero at 3361 points out of 11k
