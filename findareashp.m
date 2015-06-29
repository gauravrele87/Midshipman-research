% we are trying to analyse if the ships have any effect on the hums through analysing a single ship before and after hum.
%use the program to call the function with parameters of the file name, center, width of the ship sound and it 
%gives the power of both the initial time and the time after ie left and right of the curve  

function [arLft,arRt,wdl,wdr,erfg,maxfreql,maxfreqr] = findareashp(infile1,infile2,infile3,shpcen,shpwdth,erf,iverbose)

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


z1=y1';
z2=y2';
z3=y3';

z = [z1,z2,z3];  
y = z';

%[y,sampFreq]= wavread(infile); % reading the wave file

%plot(y);buffer=input('press any key','s'); %2000 hz * 900 secs 
%strtitle = sprintf('the erf is %d',erf);
%title(strtitle);

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
%figure(2);plot(absleft);buffer=input('press any key','s');
hleftfft = absleft(1:(floor(length(absleft)/2)));
hleftfft(1191:1211) = mean([mean(hleftfft(1181:1191)) mean(hleftfft(1216:1226))]);
hleftfft(591:611) = mean([mean(hleftfft(581:591)) mean(hleftfft(616:626))]);
%figure(3);plot(hleftfft);%buffer=input('press any key','s');
%title('hleftfft: abs(fft)')
lpwr = hleftfft.^2;  % power for the left hand side 10 seconds 
sampPts = length(y);
freq = (0:(sampFreq*10 -1)/2)/10; % 10 because its the number of seconds
dl = smooth(hleftfft,50);
%figure(4)
%plot(freq,dl);
[lymax,lxmax] = max(dl(621:1300));
cl = find(dl(621:1300) > lymax/2);
maxfreql= 62 + lxmax/10;
%save
%buffer1=input('Return to continue.','s')
cl1 = 620 + cl;
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
%arLft = wdl*lymax;
arLft = trapz(dl(cl1));
%fprintf('  %4.3f  %4.3f',arLft,wdl)



% the right one
shpright = y(i3:i4);
%plot(shpright);check properties of a file

rtfft= fft(shpright);
absrt = abs(rtfft);
%plot(absrt);

hrtfft = absrt(1:(floor(length(absrt)/2)));
hrtfft(1191:1211) = mean([mean(hrtfft(1181:1191)) mean(hrtfft(1216:1226))]);
hrtfft(591:611) = mean([mean(hrtfft(581:591)) mean(hrtfft(616:626))]);
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
cr1 = 620 + cr;
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
arRt = trapz(dr(cr1));
%arRt = wdr*rymax;
%fprintf(' %4.3f %4.3f %4.3f %4.3f \n',arLft,wdl,arRt,wdr)
%buffer = input('press any key to continue','s');


%lpwrdb = 10*log10(lpwr);
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
