iday=01;
imonth=06;
iyear=2011;

buffer0=input(sprintf('Starting day (%d):  ',iday),'s');
if length(buffer0)>0 iday=buffer0; end
buffer1=input(sprintf('Starting month (%d):  ',imonth),'s');
if length(buffer1)>0 imonth=buffer1; end
buffer2=input(sprintf('Starting year (%d):  ',iyear),'s');
if length(buffer2)>0 iyear=buffer2; end
%iday = input('enter the start day of the month: ','s');
%imonth= input('enter the starting month : ','s');
%iyear = input('enter the year: ','s');


eday = input('enter the last day of the end month: ','s');
emonth= input('enter the ending month: ','s');

iwrite= input('do you want to write in a file[1=write, 0=Do not write]:  ','s');

for cmonth=str2num(imonth):str2num(emonth)

	infile=strcat('/usr/local/data3/rtc/shp/',iyear,'/rtc',iyear(3:4),num2str(cmonth,'%02d'),'00.shp');

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



	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%{
	times = datevec(matlabday(i));  %using datevec to get all the information about year etc
	%fprintf('times: %d %d %d %d %d %f\n',times)
	years = num2str(floor(times(1)));
	months = num2str(floor(times(2)),'%02d');
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
	
	%infile1 = strcat('/usr/local/data1/rtc/wav/',years,'/',months,'/',days,'/',file(count-2).name);
	%infile2 = strcat('/usr/local/data1/rtc/wav/',years,'/',months,'/',days,'/',file(count-1).name)
	%infile3 = strcat('/usr/local/data1/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);

%[infile1,infile2,infile3] = findfile(count,file,names,years,months,days)

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	for (i=1:npt)
		
		
		[infile1,infile2,infile3,error] = findfile(matlabday(i))
		
		if error==1
			arLft(i)=0;
			arRt(i)=0;
			wdl(i)=0;
			wdr(i)=0;
			continue;
		end
			

		file1=dir(infile1);
		file2=dir(infile2);
		file3=dir(infile3);

		names1= file1.bytes;
		names2= file2.bytes;
		names3= file3.bytes;

		if names1<3600044||names2<3600044||names3<3600044
			continue;
		end
		
		[arLft(i),arRt(i),wdl(i),wdr(i)]=findareashp(infile1,infile2,infile3,xcen(i),xsig(i),erf(i),4);
		
		firstpause;
		
		
	end
	
	
	
	if str2num(iwrite)==1
		outfile=strcat('2srtc',iyear(3:4),num2str(cmonth,'%02d'),'00.shg');

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
		fclose(outfid);
	end
	
	


end
pause off
