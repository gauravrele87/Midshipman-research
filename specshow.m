

function [] =  specshow(test,matlabday,erf,xcen,ycen,xsig,arlft,arRt,r2,s2n,ybkg,pcen,ptot,fl,fr)

for i=1:length(test)
	
	
	if test(i)==1
		
		if erf(i)>3
		  fprintf('erf for no. %d is %d  \n',i,erf(i));
		  continue;
		end
	
		[infile1,infile2,infile3, error] = findfile(matlabday(i),xcen(i));	
		
		inf1 = strcat('/usr/local/data3/rtc/jpg/',infile1(26:51),'00.jpg');
		inf2 = strcat('/usr/local/data3/rtc/jpg/',infile2(26:51),'00.jpg');
		inf3 = strcat('/usr/local/data3/rtc/jpg/',infile3(26:51),'00.jpg');
		img1 = imread(inf1);
		img2 = imread(inf2);
		img3 = imread(inf3);
		img = [img1 img2 img3];
		figure(1)
		imshow(img,'InitialMagnification','fit');
		hold on
		[ht,lngth,wdth] = size(img);
		plot(5*xcen(i)*lngth/(60*45),0:307,'g')
		hleft = rectangle('position',[(5*xcen(i)-2*5*xsig(i)-5)*lngth/(60*45) 870*258/1000 10*lngth/(60*45) 70*258/1000],'EdgeColor','g','LineWidth',1);
		hright = rectangle('position',[(5*xcen(i)+2*5*xsig(i)-5)*lngth/(60*45) 870*258/1000 10*lngth/(60*45) 70*258/1000],'EdgeColor','g','LineWidth',1);
		text(50,295,['ycen=',num2str(ycen(i)),'    xsig=',num2str(5*xsig(i)),'     erf=',num2str(erf(i)),'    arlft=',num2str(arlft(i)),'    arRt=',num2str(arRt(i))])
		hold off
		figure(2)
		%plot(arlft(test),arRt(test),'.');
		plot(xsig(erf<3),ycen(erf<3),'.');
		hold on
		plot(xsig(test& erf<3),ycen(test&erf<3),'.r');
		%plot(arlft(i),arRt(i),'om');
		%xlabel('Left area');ylabel('Right Area');title('Plot of Arlft vs ArRt');
		plot(xsig(i),ycen(i),'om','markersize',15);
		xlabel('Half Width (not in secs)');ylabel('Peak height');title('Plot of Shp width vs Peak Height');
		%plot(6,0:0.00001:max(ycen(test)),'m');ylim([0 max(ycen(test))]);
		%plot(0:max(xsig(test)),0.17./(0:max(xsig(test))),'k');ylim([0 max(ycen(test))]);
		%plot(0:max(xsig(test)),0.077./(0:max(xsig(test))),'k');ylim([0 max(ycen(test))]);
		hold off
		fprintf('\n           matlabday  erf   xcen   ycen\txsig\t arlft\t arRt\tr2\t s2n\t ybkg\tpcen\tptot\tfleft  \t fright')
		fprintf('\n%s %4d %6.2f %.6f %.3f %3.3f %3.3f\t %.3f\t %.3f\t %.6f\t%.6f\t%.6f',datestr(matlabday(i)),erf(i),xcen(i),ycen(i),xsig(i),arlft(i),arRt(i),r2(i),s2n(i),ybkg(i),pcen(i),ptot(i),fl(i),fr(i));
		buffer = input('  press any key to continue','s');
	end
end
return
	













%{
infile='2srtc110700.shg';
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
%}
