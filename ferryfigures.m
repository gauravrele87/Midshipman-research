load ferrydata.mat

test1 = erf < 4 & s2n>0.5 & r2>0.8 & (weekday(matlabday)<7 & weekday(matlabday)>1);
figure(1)
plot(5*xsig(test1),ycen(test1),'.');
test2 = test1& (xsig> 3.5 & xsig<13) & ycen<0.12./xsig;
hold on
plot(5*xsig(test2),ycen(test2),'.r');
hold off
xlabel('Time taken for ships to pass(sec)','fontsize',20);
ylabel('Intensity','fontsize',20);
title('Passenger Ferries (June 2011 - October 2014)','fontsize',20);
xlim([0 150]);
ylim([0 0.04]);


figure(2)
fstime
ferrycut = erf < 4 & s2n>0.5 & r2>0.8 & erftff==0&xsig > 3.5 & xsig < 13 & ycen < 0.12./xsig & (weekday(matlabday)<7  & weekday(matlabday)>1);
plot(24*hour(ferrycut),ycen(ferrycut),'.')
hold on
plot(24*([lfnswminus lfnswplus]'),[0.003 0.003],'g','Linewidth',10)
plot(24*([lfsnwminus lfsnwplus]'),[0.003 0.003],'m','Linewidth',10)
xlim([-0.015 24*1.005]);
ylim([0 0.015]);
xlabel('Time (hours) (UT)','fontsize',20);
ylabel('Intensity','fontsize',20);
title('Passenger Ferries per day (June 2011-October 2014)','fontsize',20);
hold off

test3 = test1& (xsig> 3.5 & xsig<13) & ycen<0.12./xsig & (hour < 0.25 | hour> 0.5417);
figure(3)
plot(arlft(test3),arRt(test3),'.');
hold on;
test4 = test3 & erfNoShp2Sig==1;
test5 = test4 & erftff==0;
plot(arlft(test4),arRt(test4),'.r');
plot(arlft(test5),arRt(test5),'.g');
hold off
xlabel('Intensity before the ship passes','fontsize',20);
ylabel('Intensity after the ship passes','fontsize',20);
title('Passenger Ferries (June 2011 - October 2014)','fontsize',20);
xlim([0 5000])
ylim([0 5000])
