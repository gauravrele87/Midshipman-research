iday=01;
imonth=06;
iyear=2011;
eyear = 2011;
buffer0=input(sprintf('Starting day (%d):  ',iday),'s');
if length(buffer0)>0 iday=buffer0; end
buffer1=input(sprintf('Starting month (%d):  ',imonth),'s');
if length(buffer1)>0 imonth=buffer1; end
buffer2=input(sprintf('Starting year (%d):  ',iyear),'s');
if length(buffer2)>0 iyear=buffer2; end
%iday = input('enter the start day of the month: ','s');
%imonth= input('enter the starting month : ','s');
%iyear = input('enter the year: ','s');

emonth= input('enter the ending month: ','s');
eday = input('enter the last day of the end month: ','s');
buffer3 = input(sprintf('Ending year(%d)',eyear),'s');
if length(buffer3)>0 eyear=buffer3; end
type = input('Type of file [ 01-Ferry, 04-old]','s');


iwrite= input('do you want to write in a file[1=write, 0=Do not write]:  ','s');


startday = datenum(str2num(iyear),str2num(imonth),str2num(iday));


for cyear= str2num(iyear):str2num(eyear)
  cstryear= num2str(cyear)
  imonth = '6';
  lastmonth = '10';
  if cyear == str2num(eyear) lastmonth=emonth; end
  for cmonth=str2num(imonth):str2num(lastmonth)

	if (cmonth>10 | cmonth<6) continue; end
	
	infile=strcat('/usr/local/data3/rtc/shp/',cstryear,'/rtc',cstryear(3:4),num2str(cmonth,'%02d'),'00',sprintf('%02s',type),'.shp');
	infiletff = strcat('/usr/local/data3/rtc/tff/',cstryear,'/rtc',cstryear(3:4),num2str(cmonth,'%02d'),'00.tff');
	%infile='/usr/local/data3/rtc/shp/2011/rtc110900.shp';
	infid=fopen(infile,'r'); % opens the file with parameter read (r) or write(w)
	npt=fread(infid,1,'int32'); % integer 32 bit reading one point
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

	infidtf=fopen(infiletff,'r');  
	npttf=fread(infidtf,1,'int32'); 
	waterdaytf =fread(infidtf,npttf,'float32');
	fcentf=fread(infidtf,npttf,'float32');
	sigftf=fread(infidtf,npttf,'float32');
	s2ntf=fread(infidtf,npttf,'float32');
	pwrtf=fread(infidtf,npttf,'float32');
	pdbtf=fread(infidtf,npttf,'float32');
	erftf=fread(infidtf,npttf,'int32');
	
	arLft=zeros(npt,1);
	arRt=zeros(npt,1);
	wdl=zeros(npt,1);
	wdr=zeros(npt,1);
        fmaxL=zeros(npt,1);
        fmaxR=zeros(npt,1);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%{
	times = datevec(matlabday(i));  %using datevec to get all the information about year etc
	%fprintf('times: %d %d %d %d %d %f\n',times)
	years = num2str(floor(times(1)));
	months = num2str(floor(timShp error 
Shp error es(2)),'%02d');
	days = num2str(floor(times(3)),'%02d'); 
	hours = num2str(floor(times(4)),'%02d');	
	mins = num2str(floor(times(5)),'%02d');
	secs = num2str(floor(times(6)),'%02d');

	
	%concatenating the string to produce a path
	infile = strcat('/usr/local/data1/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
	
	file = dir(infile);
	names = {file.name}; 	
	
	for (count = 3:length(file))
        [pathstr, filename, ext] = fileparts(file(count).name);
		ihour=str2num(filename(10:11));
		imin=str2num(filename(12:13));
		isec=str2num(filename(14:15));
		filetime=datenum([times(1),times(2),times(3),ihour,imin,isec]);
		if matlabday(i) < filetime break,end
         end
	
	%infile1 = strcat('	',years,'/',months,'/',days,'/',file(count-2).name);
	%infile2 = strcat('/usr/local/data1/rtc/wav/',years,'/',months,'/',days,'/',file(count-1).name)
	%infile3 = strcat('/usr/local/data1/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);

%[infile1,infile2,infile3] = findfile(count,file,names,years,months,days)

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	for i=1:npt
		if (startday > matlabday(i))
			continue;
		end

		if erf(i)>3
			fprintf('Shp error \n');
			continue;
       		end
		
		[infile1,infile2,infile3,error] = findfile(matlabday(i),xcen(i));

		erf(i) = erf(i) + error;
		
		if erf(i)>3
			fprintf('Error detected after findfile value: %d \n',erf(i));
			continue;
       		end
        
        	%if erf(i) <= 3 
           		%inf1 = infile1(length(infile1)-18 : end);
            		%inf2 = infile2(length(infile2)-18 : end);
            		%inf3 = infile3(length(infile3)-18 : end);
            		%fprintf('inf1:%s inf2:%s inf3:%s   ',inf1,inf2,inf3);
        	%end

			
		[arLft(i),arRt(i),wdl(i),wdr(i),erfar,fmaxL(i),fmaxR(i)]=findareashp(infile1,infile2,infile3,xcen(i),xsig(i),erf(i),4);
		
		erf(i) = erf(i) + erfar;
		
		if arLft(i)==0|arRt(i)==0
			erf(i) = erf(i) + 1024;
		end
		
		firstpause;
		
		fprintf ('al=%4.2f  aR=%4.2f   erf= %d   erfar= %d   err=%d  \n',arLft(i),arRt(i),erf(i),erfar,error); 		
	end
	
	
	
	if str2num(iwrite)==1
		outfile=strcat('2srtc',cstryear(3:4),num2str(cmonth,'%02d'),'00',sprintf('%02s',type),'.shg');

		outfid=fopen(outfile,'w');
		fwrite(outfid,npt,'int32');
		fwrite(outfid,matlabday,'float64');
		fwrite(outfid,year2000,'float32'); %same as above
		fwrite(outfid,waterday,'float32');
		fwrite(outfid,erf,'float32');
		fwrite(outfid,xcen,'float32');
		fwrite(outfid,xsig,'float32');
		fwrite(outfid,ycen,'float32');
		fwrite(outfid,ybkg,'float32');
		fwrite(outfid,pcen,'float32');
		fwrite(outfid,ptot,'float32');
		fwrite(outfid,s2n,'float32'); %signal to noise ratio
		fwrite(outfid,r2,'float32'); %statistical measure of the fit
		fwrite(outfid,arLft,'float32');
		fwrite(outfid,arRt,'float32');
		fwrite(outfid,wdl,'float32');
		fwrite(outfid,wdr,'float32');
		fwrite(outfid,fmaxL,'float32');
		fwrite(outfid,fmaxR,'float32');
		fclose(outfid);
	end
	
	

  end
end
pause off
