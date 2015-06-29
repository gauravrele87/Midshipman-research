% we are trying to analyse if the ships have any effect on the hums through analysing a single ship before and after hum.
%use the program to call the function with parameters of the file name, center, width of the ship sound and it 
%gives the power of both the initial time and the time after ie left and right of the curve  

function [arLft,arRt] = findareashp(infile,shpcent,shpwdth,iverbose)

%infile= 'rtc110901044322.wav';
%[y,sampFreq]= wavread(infile); % reading the wave file

%plot(y); %2000 hz * 900 secs 
%buffer = input('press any key to continue','s');

%shpcent= 310;
%shpwdth = 20;

shpminus= shpcent - shpwdth;
shpplus = shpcent + shpwdth;

shpminus1 = shpminus +5;
shpminus2 = shpminus - 5;

shpplus1 = shpplus + 5;
shpplus2 = shpplus -5;

%this is for the 10 seconds at the start of the ship noise.
%shpleft = wavread(infile,[shpminus2*sampFreq,shpminus1*sampFreq]);
%plot(shpleft);
%`buffer = input('press any key to continue','s');
leftfft= fft(shpleft);
absleft = abs(leftfft);
plot(absleft);
buffer = input('press any key to continue','s');
hleftfft = absleft(1:(floor(length(absleft)/2)));
plot(hleftfft);
buffer = input('press any key to continue','s');
lpwr = hleftfft.^2;  % power for the left hand side 10 seconds 
sampPts = length(y);
freq = (0:(sampFreq*10 -1)/2)/10; % 10 because its the number of seconds
plot(freq,lpwr);
xlabel('Frequency in hertz');
ylabel('Power');
title('Pwr vs frequency');
buffer = input('press any key to continue','s');
dl = smooth(hleftfft,50);
plot(freq,dl);
[lymax,lxmax] = max(dl(10:length(dl)));
cl = find(dl > lymax/2);
for(rl = 1:(length(cl)-1));
	if cl(rl) == cl(rl+1) - 1 ;
		cl(rl)=0;
	else
		cl(rl) = 0;
		break;
	end	
end	
cl1 = cl(cl~=0);
psl=dl(cl1);
wdl1=cl1(1);
wdl2= cl1(length(cl1));
wdl = wdl2 - wdl1;
arLft = wdl*lymax


% the right one
shpright = wavread(infile,[shpplus2*sampFreq,shpplus1*sampFreq]);
plot(shpright);
buffer = input('press any key to continue','s');
rtfft= fft(shpright);
absrt = abs(rtfft);
plot(absrt);
buffer = input('press any key to continue','s');
hrtfft = absrt(1:(floor(length(absrt)/2)));
plot(hrtfft);
buffer = input('press any key to continue','s');
rpwr = hleftfft.^2;  % power for the left hand side 10 seconds 
freq = (0:(sampFreq*10 -1)/2)/10; % 10 because its the number of seconds
plot(freq,rpwr);
xlabel('Frequency in hertz');
ylabel('Power');
title('Pwr vs frequency');
buffer = input('press any key to continue','s');
dr = smooth(hrtfft,50);
plot(freq,dr);
[rymax,rxmax] = max(dr(10:length(dr)));
cr = find(dr > rymax/2);
for(rt = 1:(length(cr)-1));
	if cr(rt) == cr(rt+1) - 1 ;
		cr(rt)=0;
	else
		cr(rt) = 0;
		break;
	end	
end	
cr1 = cr(cr~=0);
psrl=dr(cr1);
wdr1=cr1(1);
wdr2= cr1(length(cr1));
wdr = wdr2 - wdr1;
arRt = wdr*rymax

return

end
