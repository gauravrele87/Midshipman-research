% we are trying to analyse if the ships have any effect on the hums through analysing a single ship before and after hum.
%use the program to call the function with parameters of the file name, center, width of the ship sound and it 
%gives the power of both the initial time and the time after ie left and right of the curve  

function [arLft,arRt,wdl,wdr,erfg,maxfreql,maxfreqr] = cpyfindareashp(infile1,infile2,infile3,shpcen,shpwdth,erf,iverbose)
iv4=iverbose>=4;
iv3=iverbose>=3;
iv2=iverbose>=2;
iv1=iverbose>=1;
iv0=iverbose>=0;
erfg = 0;
if iv4
	%fprintf('infile1: %s\ninfile2: %s\ninfile3: %s\n',infile1,infile2,infile3)
	%fprintf('shpcen: %f; shpwdth: %f; erf: %f\n',shpcen,shpwdth,erf)
end

%infile= 'rtc110901044322.wav';

shpcent = round(shpcen*5);  %converting xcent in to seconds
shipwdth=round(2*(shpwdth*5)); %converting wdth in to seconds 2 sigma 

[y1,sampFreq] = wavread(infile1);
[y2,sampFreq] = wavread(infile2);
[y3,sampFreq] = wavread(infile3);

infile1rdg ='/usr/local/data3/rdg/wav/2014/08/08/rdg140808212016.wav';
infile1rdh ='/usr/local/data3/rdh/wav/2014/08/08/rdh140808212016.wav';
infile2rdg ='/usr/local/data3/rdg/wav/2014/08/08/rdg140808213517.wav';
infile2rdh ='/usr/local/data3/rdh/wav/2014/08/08/rdh140808213517.wav';
infile3rdg ='/usr/local/data3/rdg/wav/2014/08/08/rdg140808215017.wav';
infile3rdh ='/usr/local/data3/rdh/wav/2014/08/08/rdh140808215017.wav';
buffer = input('press any key to continue','s')
[y1g,sampFreqg] = wavread(infile1rdg);
[y2g,sampFreqg] = wavread(infile2rdg);
[y3g,sampFreqg] = wavread(infile3rdg);

[y1h,sampFreqh] = wavread(infile1rdh);
[y2h,sampFreqh] = wavread(infile2rdh);
[y3h,sampFreqh] = wavread(infile3rdh);

%wave files
z1=y1';
z2=y2';
z3=y3';
z = [z1,z2,z3];  
y = z';

%deglitched files
z1g=y1g';
z2g=y2g';
z3g=y3g';
zg = [z1g,z2g,z3g];  
yg = zg';

%dehummed files
z1h=y1h';
z2h=y2h';
z3h=y3h';
zh = [z1h,z2h,z3h];  
yh = zh';

%[y,sampFreq]= wavread(infile); % reading the wave file
figure(19)
time = 0:1/(sampFreq):2700- 1/sampFreq;
plot(time,y);
hold on;
plot(time,yg,'r');
plot(time,yh,'g'); %2000 hz * 900 secs 
arrowObj = annotation('arrow', [shpcent*sampFreq/length(y) shpcent*sampFreq/length(y)], [0.85 0.65]);

xlim([0 2700]);
title('45 min. wav file (08/08/2014)','fontsize',20);
xlabel('Time(seconds)','fontsize',20);
ylabel('Amplitude','fontsize',20);
legend('raw wave file','deglitched','deglitched and dehummed');

hold off


shpminus= shpcent - shipwdth;
shpplus = shpcent + shipwdth;

shpminus1 = shpminus +5;
shpminus2 = shpminus - 5;

shpplus1 = shpplus + 5;
shpplus2 = shpplus -5;

if iv1
	%fprintf('shpcent: %f; shpwdth: %f; shpminus1:%f;shpminus2:%f; shpplus1=%f;shpplus2=%f; ',shpcent,shipwdth,shpminus1,shpminus2,shpplus1,shpplus2)
end


i1=shpminus2*sampFreq;
i2=shpminus1*sampFreq;
i3=shpplus2*sampFreq;
i4=shpplus1*sampFreq;



if iv1
	%fprintf('i1, i2, i3,i4 = %d, %d, %d, %d\n',i1,i2,i3,i4)
end


if i1<=0||i2<=0||i3>5400000||i4>5400000
	arLft=0;
	arRt=0;
	wdl=0;
	wdr=0;
	maxfreql=0;
	maxfreqr=0;
	fprintf('out of limits')
	erfg=erfg + 256;
	return;
end
if iv1
  %fprintf('i1, i2, i3,i4 = %d, %d, %d, %d ',i1,i2,i3,i4);
end

%hold on
%plot(i1:i2,y(i1:i2),'r')
%plot(i3:i4,y(i3:i4),'r')

%hold off
%buffer = input('press any key to continue','s');

%this is for the 10 seconds at the start of the ship noise.
shpleft = y(shpminus2*sampFreq:shpminus1*sampFreq);
%figure(1);plot(shpleft);
leftfft= fft(shpleft);
absleft = abs(leftfft);
% absleft(1:700)=0;
% absleft(1300:length(absleft))=0;
%figure(2);plot(absleft);
hleftfft = absleft(1:(floor(length(absleft)/2)));
%hleftfft(1191:1211) = mean([mean(hleftfft(1181:1191)) mean(hleftfft(1216:1226))]);
hleftfft(591:611) = mean([mean(hleftfft(581:591)) mean(hleftfft(616:626))]);
freq = (0:(sampFreq*10 -1)/2)/10; % 10 because its the number of seconds
figure(5);plot(freq,hleftfft);hold on;
title('hleftfft: abs(fft)')
lpwr = hleftfft.^2;  % power for the left hand side 10 seconds 
sampPts = length(y);

dl = smooth(hleftfft,50);
dl = smooth(hleftfft,20);
plot(freq,dl,'r','linewidth',2)
[lymax,lxmax] = max(dl(621:1300));
cl = find(dl(621:1300) > lymax/2);
cl1 = 620 + cl;
%plot(freq(cl1),dl(cl1),'k','linewidth',2)
h = area(freq(cl1),dl(cl1),'EdgeColor','none');
%alpha(h,0.2)
%plot(freq,dl,'xr','linewidth',5);
hold off
%alpha(0.2)
xlim([106.5 113])
xlabel('Frequency(Hz)','fontsize',20)
ylabel('Intensity','fontsize',20)
title('Fourier Transform of 10 second interval before the passage of a ship','fontsize',20);
maxfreql= 62 + lxmax/10;
hold off

%save

if length(cl)== 0
	arLft=0;
	arRt=0;
	wdl=0;
	wdr=0;
	maxfreql=0;
	maxfreqr=0;
	erfg=erfg + 512;
	return;
end
wdl1=cl(1)+620;
wdl2= cl(length(cl)) + 620;
wdl = (wdl2 - wdl1);
arLft = wdl*lymax;
check = trapz(dl(cl1));
fprintf('  %4.3f  %4.3f %f %f',arLft,wdl,lymax,check)



% the right one
shpright = y(i3:i4);
%plot(shpright);check properties of a file

rtfft= fft(shpright);
absrt = abs(rtfft);
%plot(absrt);

hrtfft = absrt(1:(floor(length(absrt)/2)));
%plot(hrtfft);

rpwr = hrtfft.^2;  % power for the left hand side 10 seconds 
rpwrdb = 10*log10(rpwr);
freq = (0:(sampFreq*10 -1)/2)/10; % 10 because its the number of seconds
dr = smooth(hrtfft,50);
%figure(2)
%plot(freq,dr);
[rymax,rxmax] = max(dr(621:1300));
cr = find(dr(621:1300) > rymax/2);
maxfreqr = 62 + rxmax/10; 
%%if cr(1)<35
%%	for(rt = 1:(length(cr)-1));
%%		if cr(rt) == cr(rt+1) - 1 ;
%%			cr(rt)=0;
%%		else
%%			cr(rt) = 0;
%%			break;
%%		end	
%%	end
%%end
	
%%cr1 = cr(cr~=0);
%%psrl=dr(cr1);
if length(cr)== 0
	arLft=0;
	arRt=0;
	wdl=0;
	wdr=0;
	maxfreql=0;
	maxfreqr=0;
	erfg=erfg + 512;
	return;
end
wdr1=cr(1) + 620;
wdr2= cr(length(cr)) +620;
wdr = (wdr2 - wdr1) ;
arRt = wdr*rymax;
%fprintf(' %4.3f %4.3f %4.3f %4.3f \n',arLft,wdl,arRt,wdr)
%buffer = input('press any key to continue','s');


lpwrdb = 10*log10(lpwr);
%plot(freq,lpwrdb);%buffer=input('press any key','s');
%ftest = freq > 62.0 & freq < 130.1;	
%hold on
%plot(freq(ftest),lpwrdb(ftest),'r');
%plot(freq,rpwrdb,'g');	
%plot(freq(ftest),rpwrdb(ftest),'c');
%xlabel('Frequency(Hz)','fontsize',20);
%ylabel('Power(dB)','FontSize',20);
%title('Pwr vs frequency','FontSize',20);
%legend('10 Sec interval(Left)','Frequencies considered(left)','10 Sec interval(right)','Frequencies considered(right)')
%hold off


if (arLft==0|arRt==0)
	buffer = input('press any key to continue','s');
end

return

%end
