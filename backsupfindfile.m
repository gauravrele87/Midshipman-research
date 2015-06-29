%finds the specified 3 files to be joined together to form a 45 min file and used as a function

function [infile1,infile2,infile3,erf] = findfile(matlabday)

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

		firstCount=length(newFile);

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
