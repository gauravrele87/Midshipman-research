%%%%%% Generic script to make a figure for publication.  I will try to
%%%%%% reproduce a figure in Gaurav's thesis.
%%%%%% RWB, March 3, 2015

matfilename='ferrydata.mat';
buffer1=input(sprintf('Load data file %s?  (Return = yes, or "n", or file name', ...
  matfilename),'s');
if length(buffer1)~=1
  if length(buffer1)>1 matfilename=buffer1; end
  load(matfilename)
end
%%%%%% arrays of dimension (177874x1), in ferrydata.mat 
%% arRt, arlft, erf, erfNoShp2Sig; erftff, evening, fl, fr, frhumleft
%% frhummiddle, frhumright, ft, ft0, ft1, ft2, ft3, ft4, ft5, ft6, hour
%% matlabday, matlabdaytf, mdminus, mdplus, morning, pcen, ptot, r2, s2n
%% test, test0, test1, testA, testAB, testB, testC, testD, testf, waterday
%% wdl, wdr, xcen, xsig, ybkg, ycen, year2000

%%%%%% arrays of dimension (54259x1), in ferrydata.mat
%% erftf, fcentf, pdbtf, pwrtf, s2ntf, sigftf, waterdaytf, matlabdaytf

npt=length(arRt); % all ships
test1=erf<=3; % possible ship
test2=erf==0; % better ship
test3=erftff==0; % good hum
test9=test2&test3;
npt1=sum(test1);
npt2=sum(test2);
npt3=sum(test3);
npt9=sum(test9);
fprintf('test1 (erf<=3): %d total\n',npt1)
fprintf('test2 (erf==0): %d total\n',npt2)
fprintf('test3 (erftf==0): %d total\n',npt3)
fprintf('test9 (test2&test3): %d total\n',npt9)

hold off
h1=figure(1);
fmag=1; % Change this to scale figure (including all text) up or down.

set(h1,'position',[1 1 560*fmag 560*fmag]) % 560x420 default; 560x560 square
h11=plot(arRt,arlft,'.','color',[.7 .7 .7]); % plot all points in gray
hold on
h12=plot(arRt(test9),arlft(test9),'.b'); % plot selected points in blue
hold off
legend([h11,h12],sprintf('all ships (%d)',npt1), ...
  sprintf('good ships, good hum (%d)',npt9))
title(sprintf('ferries with good ship and good hum (%d) points',npt9), ...
  'fontsize',15*fmag)
xlabel('area, after ship passes','fontsize',12*fmag)
ylabel('area, before ship passes','fontsize',12*fmag)
set(gca,'fontsize',12*fmag) % Changes font size on tick labels.

%%%%%% Methods of saving figure to a jpeg file.
%%%%%% Use SAVE on the figure bar - best appearance, I think.
%%%%%% saveas(h1,outfname)
%%%%%% print -djpeg outfname
%%%%%% I found that the points were too small in the second two methods. 
%%%%%% Maybe experimentation could improve this.
% outfname='figure99.jpg';
% buffer1=input(sprintf('Write to %s? ("y" or new file name; return to skip', ...
%   outfname),'s');
% if length(buffer1)
%   if length(buffer1)>1 outfname=buffer1; end
%   fprint(h1,outfname,'-djpeg')
% end

% buffer1=input('return to continue','s');

