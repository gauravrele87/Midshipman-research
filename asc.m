syear = input ('Enter the year','s');
startmonth = input('Enter the start month','s');
endmonth = input ('Enter the end month','s');



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

for i = str2num(startmonth):str2num(endmonth);
	infile=strcat('2srtc',syear(3:4),sprintf('%02d',i),'00.shg');
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

	infiletff = strcat('/usr/local/data3/rtc/tff/',syear,'/rtc',syear(3:4),sprintf('%02d',i),'00.tff');
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
end

erftff=zeros(npt,1);
frhummiddle = zeros(npt,1);
frhumleft = zeros(npt,1);
frhumright = zeros(npt,1);
erfNoShp2Sig=ones(npt,1);
for i=1:npt
	shlft=max(find(matlabday<matlabday(i) & erf==0));
	shrt=min(find(matlabday>matlabday(i) & erf==0)) ;
	mid=max(find(waterdaytf<waterday(i)));
	if erftf(max(find(waterdaytf<waterday(i))))~=0
		erftff(i) =erftff(i)+1 ; 
	end
	if (mid ==1 | mid==npttf)
		erftff(i) = erftff(i) + 40;
		continue;
	end
	frhummiddle(i)= fcentf(mid);
	frhumleft(i)= fcentf(mid-1);
	frhumright(i)= fcentf(mid+1);
	
	
	if erftff(i)==0&erf(i)==0
		if (isempty(shlft)==1|isempty(shrt)==1)
			continue;
		end
		erfNoShp2Sig(i) = 0;
		if (matlabday(shlft)+ datenum(0,0,0,0,0,(10*xsig(shlft)+5)))> (matlabday(i)-datenum(0,0,0,0,0,(10*xsig(i)+5)))
			erfNoShp2Sig(i)=erfNoShp2Sig(i)+50;
		end
		if (matlabday(shrt)- datenum(0,0,0,0,0,(10*xsig(shrt)+5)))< (matlabday(i)-datenum(0,0,0,0,0,(10*xsig(i)+5)))
			erfNoShp2Sig(i)=erfNoShp2Sig(i)+56;
		end
	end		
end




%plot(1:300,0.077./(1:300) ,'r');ylim([0 0.12])
%plot(1:300,0.17./(1:300) ,'r');ylim([0 0.12])
