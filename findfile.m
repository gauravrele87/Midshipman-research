%finds the specified 3 files to be joined together to form a 45 min file and used as a function
%matlabday  is the specific matlabday of the peak ship. 

function [infile1,infile2,infile3,erf] = findfile(matlabday,xcen)
iverbose=0;
erf = 0;
infile1 = ' ';
infile2 = ' ';
infile3 = ' ';
ifpath= '/usr/local/data3/rtc/wav/';
if iverbose>=4 fprintf('matlabday: %f; xcen: %f\n',matlabday,xcen), end

shpcen15 = (xcen*5)/86400; 

mld2 = matlabday -xcen*5/86400 + 900/86400; % Start of middle file.
[iy2,im2,id2,ih2,imin2,sec2]=datevec(mld2);
isec2= round(sec2);
if isec2==60
	mld2 = mld2 + (1.25 - mod(sec2,1))/86400; % Start of middle file.
	[iy2,im2,id2,ih2,imin2,sec2]=datevec(mld2);
	isec2 = round(sec2);
end
infile2=sprintf('%s%04d/%02d/%02d/rtc%02d%02d%02d%02d%02d%02d.wav', ...
  ifpath,iy2,im2,id2,mod(iy2,100),im2,id2,ih2,imin2,isec2);
if exist(infile2)~=2
	fprintf('Middle file %s not found.\n',infile2);
	erf=erf+32;
	%buffer = input('press any key to continue','s');
	return
end

mld1 = mld2-900/86400; % matlabday of the start of the first file.
[iy1,im1,id1,ih1,imin1,sec1]=datevec(mld1);
isec1=round(sec1);
infile1=sprintf('%s%04d/%02d/%02d/rtc%02d%02d%02d%02d%02d%02d.wav', ...
  ifpath,iy1,im1,id1,mod(iy1,100),im1,id1,ih1,imin1,isec1);
if exist(infile1)~=2
	%fprintf('%s not found; check string 1 second eariler.\n',infile1)
	mld1 = mld2 - 901/86400;
	[iy1,im1,id1,ih1,imin1,sec1]=datevec(mld1);
	isec1= round(sec1);
	infile1=sprintf('%s%04d/%02d/%02d/rtc%02d%02d%02d%02d%02d%02d.wav', ...
  	  ifpath,iy1,im1,id1,mod(iy1,100),im1,id1,ih1,imin1,isec1);
  	if isec1==60
		mld1 = mld1 + (1.25 - mod(sec1,1))/86400; % Start of middle file.
		[iy1,im1,id1,ih1,imin1,sec1]=datevec(mld1);
		isec1 = round(sec1);
		infile1=sprintf('%s%04d/%02d/%02d/rtc%02d%02d%02d%02d%02d%02d.wav', ...
  	  ifpath,iy1,im1,id1,mod(iy1,100),im1,id1,ih1,imin1,isec1);
	end
	
	if exist(infile1)~=2
		fprintf('iy1: %d; im1: %d; id1: %d; ih1: %d; imin1: %d; sec1: %f; isec1: %d\n', ...
	  iy1,im1,id1,ih1,imin1,sec1,isec1)
		fprintf('Cant find left file %s \n',infile1);
		%buffer = input('press any key to continue','s');
		erf=erf+32;
		return
	end
end


mld3 = mld2 + 900/86400;
[iy3,im3,id3,ih3,imin3,sec3]=datevec(mld3);
isec3=round(sec3);
infile3=sprintf('%s%04d/%02d/%02d/rtc%02d%02d%02d%02d%02d%02d.wav', ...
  ifpath,iy3,im3,id3,mod(iy3,100),im3,id3,ih3,imin3,isec3); % Start of middle file.
[iy2,im2,id2,ih2,imin2,sec2]=datevec(mld2);
if exist(infile3)~=2
	mld3 = mld2 + 901/86400;
	[iy3,im3,id3,ih3,imin3,sec3]=datevec(mld3);
	isec3=round(sec3);
	infile3=sprintf('%s%04d/%02d/%02d/rtc%02d%02d%02d%02d%02d%02d.wav', ...
	  ifpath,iy3,im3,id3,mod(iy3,100),im3,id3,ih3,imin3,isec3);
	if isec3==60
		mld3 = mld3 + (1.25 - mod(sec3,1))/86400; % Start of middle file.
		[iy3,im3,id3,ih3,imin3,sec3]=datevec(mld3);
		isec3 = round(sec3);
		infile3=sprintf('%s%04d/%02d/%02d/rtc%02d%02d%02d%02d%02d%02d.wav', ...
	  ifpath,iy3,im3,id3,mod(iy3,100),im3,id3,ih3,imin3,isec3);
	end
	
	if exist(infile3)~=2
		fprintf('iy3: %d; im3: %d; id3: %d; ih3: %d; imin3: %d; sec3: %f; isec3: %d\n', ...
	  iy3,im3,id3,ih3,imin3,sec3,isec3)
		fprintf('Cant find right file %s\n',infile3);
		erf=erf+32;
		%buffer = input('press any key to continue','s');
		return
	end
end


file1=dir(infile1);
file2=dir(infile2);
file3=dir(infile3);

names1= file1.bytes;
names2= file2.bytes;
names3= file3.bytes;

if names1<3600044||names2<3600044||names3<3600044
	erf = erf + 64;
	fprintf(' names are out of bound \n');
	return;
end

[m1 d1] = wavfinfo(infile1);
[m2 d2] = wavfinfo(infile2);
[m3 d3] = wavfinfo(infile3);
if length(m1)*length(m2)*length(m3) == 0
	erf = erf+ 128;
	fprintf('Error in wav file\n');
	%buffer = input('press any key to continue','s');
	return;
end

if iverbose>=2
	fprintf ('infile1: %s\n infile2:%s\n infile3:%s\n error: %d\n',infile1,infile2,infile3,erf);
end


return













































































times = datevec(matlabday - shpcen15 + 900/86400);

years = num2str(floor(times(1)));
months = num2str(floor(times(2)),'%02d');
days = num2str(floor(times(3)),'%02d'); 
hours = num2str(floor(times(4)),'%02d');
mins = num2str(floor(times(5)),'%02d');
secs = num2str(floor(times(6)),'%02d');
infile3 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','rtc',years(3:4),months,days,hours,mins,secs,'.wav');
inf3 = strcat('rtc',years(3:4),months,days,hours,mins,secs,'.wav');

if exist(infile3)~=2
	sec = num2str((str2num(secs) + 1));
	infile3 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','rtc',years(3:4),months,days,hours,mins,sec,'.wav');
	inf3 = strcat('rtc',years(3:4),months,days,hours,mins,sec,'.wav');
	if exist(infile3)~=2
		fprintf('\n check the string 3 name for %s',infile3)
		infile1 =  0;
		infile2 = 0;
		infile3 = 0;
		erf = 1;
		return;
	end
end




file1 = dir(infile1);
file2 = dir(infile2);
file3 = dir(infile3);
















































































































%{
erf=0;
datestr(matlabday)

times = datevec(matlabday);  %using datevec to get all the information about year etc
	
years = num2str(floor(times(1)));
months = num2str(floor(times(2)),'%02d');
days = num2str(floor(times(3)),'%02d'); 
hours = num2str(floor(times(4)),'%02d');
mins = num2str(floor(times(5)),'%02d');
secs = num2str(floor(times(6)),'%02d');

	
	%concatenating the string to produce a path
infile = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
	
file = dir(infile);
names = {file.name}; 	
	
for (count = 1:(length(file)))
        [pathstr, filename, ext] = fileparts(file(count).name);
	ihour=str2num(filename(10:11));
	imin=str2num(filename(12:13));
	isec=str2num(filename(14:15));
	filetime=datenum([times(1),times(2),times(3),ihour,imin,isec]);
	if matlabday < filetime break,end

	if count==length(file)
		fprintf('got into the first count:%d matlabday:%s filetime: %s \n',count,datestr(matlabday),datestr(filetime))
		if matlabday > filetime
			count=length(file)+1;
			fprintf('got inside the second if,count: %d \n',count)
		end
	end
end

count

	infileold = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
	
		file=dir(infileold);

if count==1
	if str2num(months)==01
		if str2num(days)==01
	
			newYears=num2str(str2num(years)-1);
			newMonth= num2str(12);
			newDays=num2str(31);
			
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end	
			newFile=dir(infile);
			

		else 
		%newMonth=str2num(months)-1;
		%newDay=eomday(str2num(years),newMonth);
			newDays=num2str(str2num(days)-1,'%02d');
			newYears=years;
			newMonth=months;
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end	
			newFile=dir(infile);
			
		end

		lastcount=length(newFile);


infile1= strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/',newFile(lastcount-1).name);
		infileold = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
		file=dir(infileold);	
		infile2 = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/',newFile(lastcount).name);
		infile3 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);

	else
		if str2num(days)==01
	
			newMonth=num2str(str2num(months)-1,'%02d');
			newDays=num2str(eomday(str2num(years),str2num(newMonth)),'%02d');
			newYears=years
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end	
			newFile=dir(infile);
			

		else 
		%newMonth=str2num(months)-1;
		%newDay=eomday(str2num(years),newMonth);
			newDays=num2str(str2num(days)-1,'%02d');
			newYears=years;
			newMonth=months;
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');	
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
			newFile=dir(infile);
			
		end

		lastcount=length(newFile);
		infile1= strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/',newFile(lastcount-1).name);
		infileold = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
		file=dir(infileold);	
		infile2 = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/',newFile(lastcount).name);
		infile3 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);
	end			
end







if count==2
	if str2num(months)==01
		if str2num(days)==01
	
			newYears=num2str(str2num(years)-1);
			newMonth= num2str(12);
			newDays=num2str(31);
			
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');	
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
			newFile=dir(infile);
			

		else 
		%newMonth=str2num(months)-1;
		%newDay=eomday(str2num(years),newMonth);
			newDays=num2str(str2num(days)-1,'%02d');
			newYears=years;
			newMonth=months;
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');	
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
			newFile=dir(infile);
			
		end

		lastcount=length(newFile);


infile1= strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/',newFile(lastcount).name);
		infileold = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
		file=dir(infileold);	
		infile2 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count-1).name);
		infile3 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);

	else
		if str2num(days)==01
	
			newMonth=num2str(str2num(months)-1,'%02d');
			newDays=num2str(eomday(str2num(years),str2num(newMonth)),'%02d');
			newYears=years
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');	
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
			newFile=dir(infile);
			

		else 
		%newMonth=str2num(months)-1;
		%newDay=eomday(str2num(years),newMonth);
			newDays=num2str(str2num(days)-1,'%02d')
			newYears=years
			newMonth=months
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav')
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end	
			newFile=dir(infile)
			
		end

		lastcount=length(newFile);
		infile1= strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/',newFile(lastcount).name);
		infileold = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
		file=dir(infileold);	
		infile2 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count-1).name);
		infile3 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);
	end			
end

if count > 2
	if count < (length(file)+1)
		
		infile1 = strcat('/usr/local/data1/rtc/wav/',years,'/',months,'/',days,'/',file(count-2).name);
		infiles = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
		infile2 = strcat('/usr/local/data1/rtc/wav/',years,'/',months,'/',days,'/',file(count-1).name);
		infile3 = strcat('/usr/local/data1/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
if count==length(file)
	if str2num(months)==12
		if str2num(days)==31
	
			newYears=num2str(str2num(years)+1);
			newMonth= num2str(01);
			newDays=num2str(01);
			
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');
			if exist(infile1)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end	
			newFile=dir(infile);
			

		else 
		%newMonth=str2num(months)-1;
		%newDay=eomday(str2num(years),newMonth);
			newDays=num2str(str2num(days)+1,'%02d');
			newYears=years;
			newMonth=months;
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');	
			if exist(infile1)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
			newFile=dir(infile);
			
		end

		firstCount=length(newFile);

		infileold = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
		file=dir(infileold);	
		infile1 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count-2).name);
		infile2 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count-1).name);
		infile3 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);

	else
		if str2num(days)==eomday(str2num(years),str2num(months))
	
			newMonth=num2str(str2num(months)+1,'%02d');
			newDays=num2str(01,'%02d');
			newYears=years;
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');	
			if exist(infile1)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
			newFile=dir(infile);
			

		else 
		%newMonth=str2num(months)+1;
		%newDay=eomday(str2num(years),newMonth);
			newDays=num2str(str2num(days)+1,'%02d');
			newYears=years;
			newMonth=months;
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');
			if exist(infile1)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end	
			newFile=dir(infile);
			
		end

		
		firstCount=length(newFile);

		infileold = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
		if exist(infileold)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
		file=dir(infileold);	
		infile1 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count-1).name);
		infile2 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);
		infile3 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count).name);
	end
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if count==(length(file)+1)
	if str2num(months)==12
		if str2num(days)==31
	
			newYears=num2str(str2num(years)+1);
			newMonth= num2str(01);
			newDays=num2str(01);
			
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');	
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
			newFile=dir(infile);
			

		else 
		%newMonth=str2num(months)-1;
		%newDay=eomday(str2num(years),newMonth);
			newDays=num2str(str2num(days)+1,'%02d');
			newYears=years;
			newMonth=months;
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav');	
			infiles = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays);
			if exist(infiles)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
			newFile=dir(infile);
			
		end

infile = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');		firstCount=length(newFile);

		infileold = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav');
		file=dir(infileold);	
		infile1 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count-2).name);
		infile2 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count-1).name);
		infile3= strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/',newFile(1).name);

	else
		if str2num(days)==eomday(str2num(years),str2num(months))
	
			newMonth=num2str(str2num(months)+1,'%02d');
			newDays=num2str(01,'%02d');
			newYears=years;
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav')
			if exist(infile)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end	
			newFile=dir(infile);
			

		else 
		%newMonth=str2num(months)+1
		%newDay=eomday(str2num(years),newMonth)
			newDays=num2str(str2num(days)+1,'%02d')
			newYears=years
			newMonth=months
			infile = strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/','*.wav')
			if exist(infile)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
			newFile=dir(infile);
			
		end
		firstCount=length(newFile)

		infileold = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/','*.wav')
		if exist(infileold)~=7
				erf=1;
				infile1='0';
				infile2='0';
				infile3='0';
				return;
			end
		file=dir(infileold);	
		infile1 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count-2).name)
		infile2 = strcat('/usr/local/data3/rtc/wav/',years,'/',months,'/',days,'/',file(count-1).name)
		infile3= strcat('/usr/local/data3/rtc/wav/',newYears,'/',newMonth,'/',newDays,'/',newFile(1).name)
	end
end


end
%}
