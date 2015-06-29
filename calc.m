iday=01;
imonth=06;
iyear=2011;
eyear = 2014;
buffer0=input(sprintf('Starting day (%d):  ',iday),'s');
if length(buffer0)>0 iday=buffer0; end
buffer1=input(sprintf('Starting month (%d):  ',imonth),'s');
if length(buffer1)>0 imonth=buffer1; end
buffer2=input(sprintf('Starting year (%d):  ',iyear),'s');
if length(buffer2)>0 iyear=buffer2; end
emonth= input('enter the ending month: ','s');
eday = input('enter the last day of the end month: ','s');
buffer3 = input(sprintf('Ending year(%d)',eyear),'s');
if length(buffer3)>0 eyear=buffer3; end
type = input('Type of file [ 01-Ferry, 04-old]','s');

npt=0;
matlabday=zeros(0,0);
year2000=zeros(0,0);
waterday=zeros(0,0);
erf=zeros(0,0);
xcen=zeros(0,0);
xsig=zeros(0,0);
ycen=zeros(0,0);
ybkg=zeros(0,0);
pcen=zeros(0,0);
ptot=zeros(0,0);
s2n=zeros(0,0);
r2=zeros(0,0);
arlft=zeros(0,0);
arRt=zeros(0,0);
wdl=zeros(0,0);
wdr=zeros(0,0);
fl=zeros(0,0);
fr=zeros(0,0);
hour = zeros(0,0);

npttf=0;
waterdaytf =zeros(0,0);
fcentf=zeros(0,0);
sigftf=zeros(0,0);
s2ntf=zeros(0,0);
pwrtf=zeros(0,0);
pdbtf=zeros(0,0);
erftf=zeros(0,0);
matlabdaytf = zeros(0,0);

for cyear= str2num(iyear):str2num(eyear)
  cstryear= num2str(cyear);
  imonth = '6';
  lastmonth = '10';
  if cyear == str2num(eyear) lastmonth=emonth; end
  for i = str2num(imonth):str2num(lastmonth)
	infile=strcat('/usr/local/data3/rtc/shp/',cstryear,'/rtc',cstryear(3:4),sprintf('%02d',i),'00.shp');
	infile = strcat('2srtc',cstryear(3:4),sprintf('%02d',i),'00',sprintf('%02s',type),'.shg');
	infid=fopen(infile,'r'); % opens the file with parameter read (r) or write(w)
	npt1=fread(infid,1,'int32'); % integer 32 bit reading one point
	matlabday1=fread(infid,npt1,'float64');  %npt is dimension of array, date 
	year20001=fread(infid,npt1,'float32'); %same as above
	waterday1=fread(infid,npt1,'float32');
	erf1=fread(infid,npt1,'float32');
	xcen1=fread(infid,npt1,'float32');
	xsig1=fread(infid,npt1,'float32');
	ycen1=fread(infid,npt1,'float32');
	ybkg1=fread(infid,npt1,'float32');
	pcen1=fread(infid,npt1,'float32');
	ptot1=fread(infid,npt1,'float32');
	s2n1=fread(infid,npt1,'float32'); %signal to noise ratio
	r21=fread(infid,npt1,'float32'); %statistical measure of the fit
	arlft1=fread(infid,npt1,'float32');
	arRt1=fread(infid,npt1,'float32');
	wdl1=fread(infid,npt1,'float32');
	wdr1=fread(infid,npt1,'float32');
	fl1=fread(infid,npt1,'float32');
	fr1=fread(infid,npt1,'float32');
	hour1 = mod(matlabday1,1);

	infiletff = strcat('/usr/local/data3/rtc/tff/',cstryear,'/rtc',cstryear(3:4),sprintf('%02d',i),'00.tff');
	infidtf=fopen(infiletff,'r');  
	npttf1=fread(infidtf,1,'int32'); 
	waterdaytf1 =fread(infidtf,npttf1,'float32');
	fcentf1=fread(infidtf,npttf1,'float32');
	sigftf1=fread(infidtf,npttf1,'float32');
	s2ntf1=fread(infidtf,npttf1,'float32');
	pwrtf1=fread(infidtf,npttf1,'float32');
	pdbtf1=fread(infidtf,npttf1,'float32');
	erftf1=fread(infidtf,npttf1,'int32');
	
	npt=npt+npt1;
	matlabday=[matlabday ;matlabday1];
	year2000=[year2000 ;year20001];
	waterday=[waterday ;waterday1];
	erf=[erf ;erf1];
	xcen=[xcen ;xcen1];
	xsig=[xsig ;xsig1];
	ycen=[ycen ;ycen1];
	ybkg=[ybkg ;ybkg1];
	pcen=[pcen ;pcen1];
	ptot=[ptot ;ptot1];
	s2n=[s2n ;s2n1];
	r2=[r2 ;r21];
	arlft=[arlft ;arlft1];
	arRt=[arRt ;arRt1];
	wdl=[wdl ;wdl1];
	wdr=[wdr ;wdr1];
	fl = [fl ;fl1];
	fr=[fr; fr1];
	hour = [hour ;hour1];

	npttf=npttf +npttf1;
	waterdaytf =[waterdaytf; waterdaytf1];
	fcentf=[fcentf ;fcentf1];
	sigftf=[sigftf ;sigftf1];
	s2ntf=[s2ntf ;s2ntf1];
	pwrtf=[pwrtf ;pwrtf1];
	pdbtf=[pdbtf; pdbtf1];
	erftf=[erftf ;erftf1];
	matlabdaytf = [matlabdaytf; waterdaytf + datenum(cyear,0,0,0,0,0)];	
  end
end

erftff=zeros(npt,1);
frhummiddle = zeros(npt,1);
frhumleft = zeros(npt,1);
frhumright = zeros(npt,1);
erfNoShp2Sig=ones(npt,1);

mdplus = matlabday + (10*xsig+5)/86400; % 2 sigma to the right
mdminus = matlabday - (10*xsig+5)/86400;% 2 sigma to the left

count=1; %counter for TF error array conversion to SHP array size

for i=1:npt
	i1 = max(1,i-20);
	i2 = min(npt,i+20);
	
	%i3 = max(1,i-20);
	%mid=i3-1 + find(max(waterdaytf((find(waterdaytf<waterday(i))))));
	
	for j=max(count,1):npttf
	  	if matlabdaytf(j) > matlabday(i)
	  		if erftf(j-1)~=0
	  			erftff(i)=1;
	  		end
	  		count = j-2;
	  		break
	  	end
	end
	
	
	shlft= mdminus(i1:i2)> mdplus(i);
	%shrt=find(min(matlabday(i1-1 + find(mdplus(i1:i2)>matlabday(i) & erf(i1:i2) < 3))));
	shrt = mdplus(i1:i2)< mdminus(i);
	
	erfNoShp2Sig(i) = sum(~(shrt|shlft) & r2(i1:i2)> 0.8);
	%fprintf('erf(%d)=%d \n',i,erfNoShp2Sig(i));
	
	
end



fstime % script for the ferry times comparison returning "testf" variable
test = hour> 0.5411 & hour< 0.5453 & erf<3 & s2n>1;
test0 = erf<3;
figure(6)
plot(xsig(test),ycen(test),'.');
test = hour> 0.5411 & hour< 0.5453 & erf<3 & s2n>1& weekday(matlabday)<7 & weekday(matlabday)>1;



% Ferry Tests (ft)

if str2num(type)==01
  ft0 = erf < 4 & s2n>0.5 & r2>0.8 & erftff==0 & (hour < 0.25 | hour> 0.5417) & (weekday(matlabday)<7  & weekday(matlabday)>1);
  ft1 = erfNoShp2Sig==1;
  ft2 = xsig > 3.5 & xsig < 13;
  ft3 = ycen < 0.12./xsig;
  ft4 = testf;
  ft5 = (fr> 70 & fl>70);
  ft6 = (fr<117 & fl<117);
  ft = ft0&ft1&ft2&ft3;
  morning = ft & hour < 0.7917;
  evening = ft & hour > 0.7917;


  ferrycut = erf < 4 & s2n>0.5 & r2>0.8 & erftff==0&xsig > 3.5 & xsig < 13 & ycen < 0.12./xsig & (weekday(matlabday)<7  & weekday(matlabday)>1);
  plot(24*hour(ferrycut),ycen(ferrycut),'.')
  hold on
  plot(24*([lfnswminus lfnswplus]'),[0.001 0.001],'g','Linewidth',10)
  plot(24*([lfsnwminus lfsnwplus]'),[0.001 0.001],'m','Linewidth',10)
  xlim([-0.015 24*1.005]);
  xlabel('Time (hours) (UT)','fontsize',15);
  ylabel('Intensity','fontsize',15);
  title('Passenger Ferries per day (June 2011-October 2014)','fontsize',15);
  hold off

  test1 = ft0;
  ast1 = (arlft(test1) - arRt(test1))./(arlft(test1) + arRt(test1));
  Nt1plus = length(ast1(ast1>0));
  Nt1min = length(ast1(ast1<0));
  Ntot1 = length(ast1);
  difft1 = Nt1plus - Nt1min;
  sigdifft1 = sqrt(Nt1plus + Nt1min);

  testA = test1&ft1; 
  astA = (arlft(testA) - arRt(testA))./(arlft(testA) + arRt(testA));
  NtAplus = length(astA(astA>0));
  NtAmin = length(astA(astA<0));
  NtotA = length(astA);
  difftA = NtAplus - NtAmin;
  sigdifftA = sqrt(NtAplus + NtAmin);


  testB = testA& ft2;
  astB = (arlft(testB) - arRt(testB))./(arlft(testB) + arRt(testB));
  NtBplus = length(astB(astB>0));
  NtBmin = length(astB(astB<0));
  NtotB = length(astB);
  difftB = NtBplus - NtBmin;
  sigdifftB = sqrt(NtBplus + NtBmin);
  ft5 = (fr> 70 & fl>70);
  ft6 = (fr<117 & fl<117)
  
  testC = testB&ft3;
  astC = (arlft(testC) - arRt(testC))./(arlft(testC) + arRt(testC));
  NtCplus = length(astC(astC>0));
  NtCmin = length(astC(astC<0));
  NtotC = length(astC);
  difftC = NtCplus - NtCmin;
  sigdifftC = sqrt(NtCplus + NtCmin);


  testD = morning;
  astD = (arlft(testD) - arRt(testD))./(arlft(testD) + arRt(testD));
  NtDplus = length(astD(astD>0));
  NtDmin = length(astD(astD<0));
  NtotD = length(astD);
  difftD= NtDplus - NtDmin;
  sigdifftD = sqrt(NtDplus + NtDmin);
erf < 4 
  testAB = evening;
  astAB = (arlft(testAB) - arRt(testAB))./(arlft(testAB) + arRt(testAB));
  NtABplus = length(astAB(astAB>0)); 
  NtABmin = length(astAB(astAB<0));
  NtotAB = length(astAB);
  difftAB= NtABplus - NtABmin;
  sigdifftAB = sqrt(NtABplus + NtABmin);

  testff = testf&ft;
  astf = (arlft(testff) - arRt(testff))./(arlft(testff) + arRt(testff));
  Ntfplus = length(astf(astf>0));
  Ntfmin = length(astf(astf<0));
  Ntotf = length(astf);
  difftf = Ntfplus - Ntfmin;
  sigdifftf = sqrt(Ntfplus + Ntfmin);

  fprintf('Total Ships: %d \n',npt);
  fprintf('Condition  Ntotal Nleft NRight\tDiff\n');
  fprintf('Test1     :%d\t %d\t %d\t %f %c %f \n',Ntot1,Nt1plus,Nt1min,difft1,177,sigdifft1); 
  fprintf('TestA     :%d\t %d\t %d\t %f %c %f \n',NtotA,NtAplus,NtAmin,difftA,177,sigdifftA); 
  fprintf('TestB     :%d\t %d\t %d\t %f %c %f \n',NtotB,NtBplus,NtBmin,difftB,177,sigdifftB); 
  fprintf('TestC     :%d\t %d\t %d\t %f %c %f \n',NtotC,NtCplus,NtCmin,difftC,177,sigdifftC); 
  fprintf('Morning   :%d\t %d\t %d\t %f %c %f \n',NtotD,NtDplus,NtDmin,difftD,177,sigdifftD); 
  fprintf('Evening   :%d\t %d\t %d\t %f %c %f \n',NtotAB,NtABplus,NtABmin,difftAB,177,sigdifftAB); 
  fprintf('Ferry Time:%d\t %d\t %d\t %f %c %f \n',Ntotf,Ntfplus,Ntfmin,difftf,177,sigdifftf);

end




%tanker type
if str2num(type)==04
  ft0 = erf ==0 & erftff==0;
  ft1 = erfNoShp2Sig==1;
  ft2 = xsig > 13 & xsig < 35;
  ft3 = ycen > 0.15./xsig;
  ft5 = (fr> 70 & fl>70);
  ft6 = (fr<117 & fl<117);
  ft = ft0&ft1&ft2&ft3;
  
  
  test1 = ft0;
  ast1 = (arlft(test1) - arRt(test1))./(arlft(test1) + arRt(test1));
  Nt1plus = length(ast1(ast1>0));
  Nt1min = length(ast1(ast1<0));
  Ntot1 = length(ast1);
  difft1 = Nt1plus - Nt1min;
  sigdifft1 = sqrt(Nt1plus + Nt1min);

  testA = test1&ft1; 
  astA = (arlft(testA) - arRt(testA))./(arlft(testA) + arRt(testA));
  NtAplus = length(astA(astA>0));
  NtAmin = length(astA(astA<0));
  NtotA = length(astA);
  difftA = NtAplus - NtAmin;
  sigdifftA = sqrt(NtAplus + NtAmin);


  testB = testA& ft2;
  astB = (arlft(testB) - arRt(testB))./(arlft(testB) + arRt(testB));
  NtBplus = length(astB(astB>0));
  NtBmin = length(astB(astB<0));
  NtotB = length(astB);
  difftB = NtBplus - NtBmin;
  sigdifftB = sqrt(NtBplus + NtBmin);

  testC = testB&ft3;
  astC = (arlft(testC) - arRt(testC))./(arlft(testC) + arRt(testC));
  NtCplus = length(astC(astC>0));
  NtCmin = length(astC(astC<0));
  NtotC = length(astC);
  difftC = NtCplus - NtCmin;
  sigdifftC = sqrt(NtCplus + NtCmin);


  
  fprintf('Total Ships: %d',npt);
  fprintf('Condition  Ntotal Nleft NRight\tDiff\n');
  fprintf('Test1     :%d\t %d\t %d\t %f %c %f \n',Ntot1,Nt1plus,Nt1min,difft1,177,sigdifft1); 
  fprintf('TestA     :%d\t %d\t %d\t %f %c %f \n',NtotA,NtAplus,NtAmin,difftA,177,sigdifftA); 
  fprintf('TestB     :%d\t %d\t %d\t %f %c %f \n',NtotB,NtBplus,NtBmin,difftB,177,sigdifftB); 
  fprintf('TestC     :%d\t %d\t %d\t %f %c %f \n',NtotC,NtCplus,NtCmin,difftC,177,sigdifftC); 
  %fprintf('Morning   :%d\t %d\t %d\t %f %c %f \n',NtotD,NtDplus,NtDmin,difftD,177,sigdifftD); 
  %fprintf('Evening   :%d\t %d\t %d\t %f %c %f \n',NtotAB,NtABplus,NtABmin,difftAB,177,sigdifftAB); 
  %fprintf('Ferry Time:%d\t %d\t %d\t %f %c %f \n',Ntotf,Ntfplus,Ntfmin,difftf,177,sigdifftf);

end
	
%{
%	if (mid ==1 | mid==npttf)
%		erftff(i) = erftff(i) + 40;
%		continue;
%	end
%	if erftf(max(find(waterdaytf<waterday(i))))~=0
%		erftff(i) =erftff(i)+1 ; 
%	end
	fprintf('Hello');
	%frhummiddle(i)= fcentf(mid);
	%frhumleft(i)= fcentf(mid-1);
	%frhumright(i)= fcentf(mid+1);
	
	
	if erftff(i)==0&erf(i)< 3
		if (isempty(shlft)==1|isempty(shrt)==1)
			continue;
	if (isempty(shlft)==1|isempty(shrt)==1)
		erfNoShp2Sig(i)=1;
		continue;
	end
	
	erfNoShp2Sig(i) = 0;
	if (matlabday(shlft)+ datenum(0,0,0,0,0,(10*xsig(shlft)+5)))> (matlabday(i)-datenum(0,0,0,0,0,(10*xsig(i)+5)))
		erfNoShp2Sig(i)=erfNoShp2Sig(i)+50;
	end
	if (matlabday(shrt)- datenum(0,0,0,0,0,(10*xsig(shrt)+5)))< (matlabday(i)-datenum(0,0,0,0,0,(10*xsig(i)+5)))
		erfNoShp2Sig(i)=erfNoShp2Sig(i)+56;
	end		
%}
