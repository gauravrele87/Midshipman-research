infile='2srtc110600.shg';
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
fmaxl=fread(infid,npt,'float32');
fmaxr=fread(infid,npt,'float32');

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
	for j=1:npttf
		if (waterday(i) - waterdaytf(i))<0.0104
			if erftf~=0 erf = erf + 200; end
		end
	end
end
			
