%function that concatenates 3 wav files with the input as count,year,month, day and the wav file name

if( (count-1)<1)
	if (day==1)
		if (month ==1)
			year= year -1;
			month = 12;
			day = eomday(year,month);
		else 
			month = month -1;
			day = eomday(year,month);
		end
	else 
		day = day - 1;
	end
	infileSearch = strcat('/usr/local/data1/rtc/wav/',year,'/',month,'/',day,'/');
			
 

