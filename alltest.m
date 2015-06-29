
asc

test00 = (erftff==0);
test01= (erf==0);	
test02 = (abs(fl-fr)<3);
test03 = (fl<115)&(fr<115);
test04 = (erfNoShp2Sig ==0);
test1 = test01&test00&test02&test03;


%test1= (erf==0);
ast1 = (arlft(test1) - arRt(test1))./(arlft(test1) + arRt(test1));
Nt1plus = length(ast1(ast1>0));
Nt1min = length(ast1(ast1<0));
Ntot1 = length(ast1);
difft1 = Nt1plus - Nt1min;
sigdifft1 = sqrt(Nt1plus + Nt1min);

%testA = test1&(ycen < 0.027*(1-xsig/28)); %below highest (tankers)line from y=0.027 to zero for xsig 28
testA = test1&ycen< 0.17./xsig;
astA = (arlft(testA) - arRt(testA))./(arlft(testA) + arRt(testA));
NtAplus = length(astA(astA>0));
NtAmin = length(astA(astA<0));
NtotA = length(astA);
difftA = NtAplus - NtAmin;
sigdifftA = sqrt(NtAplus + NtAmin);

%testB = test1&(ycen <0.018*(1-xsig/15));%below (ferry,small ships) (middle)line from y=0.018 to zero for xsdatestr(matlabday(find(erf==0)))ig 15
testB = test1& 0.077./xsig;
astB = (arlft(testB) - arRt(testB))./(arlft(testB) + arRt(testB));
NtBplus = length(astB(astB>0));
NtBmin = length(astB(astB<0));
NtotB = length(astB);
difftB = NtBplus - NtBmin;
sigdifftB = sqrt(NtBplus + NtBmin);

testC = test1&(xsig<5);
astC = (arlft(testC) - arRt(testC))./(arlft(testC) + arRt(testC));
NtCplus = length(astC(astC>0));
NtCmin = length(astC(astC<0));
NtotC = length(astC);
difftC = NtCplus - NtCmin;
sigdifftC = sqrt(NtCplus + NtCmin);

testD = test1&(hour<0.25|hour> 0.525);
astD = (arlft(testD) - arRt(testD))./(arlft(testD) + arRt(testD));
NtDplus = length(astD(astD>0));
NtDmin = length(astD(astD<0));
NtotD = length(astD);
difftD= NtDplus - NtDmin;
sigdifftD = sqrt(NtDplus + NtDmin);

testAB = test1&(ycen < 0.027*(1-xsig/28))&(ycen>0.018*(1-xsig/15));
astAB = (arlft(testAB) - arRt(testAB))./(arlft(testAB) + arRt(testAB));
NtABplus = length(astAB(astAB>0));
NtABmin = length(astAB(astAB<0));
NtotAB = length(astAB);
difftAB= NtABplus - NtABmin;
sigdifftAB = sqrt(NtABplus + NtABmin);

testBCbar = testB&(~testC);
astBCbar = (arlft(testBCbar) - arRt(testBCbar))./(arlft(testBCbar) + arRt(testBCbar));
NtBCbarplus = length(astBCbar(astBCbar>0));
NtBCbarmin = length(astBCbar(astBCbar<0));
NtotBCbar = length(astBCbar);
difftBCbar= NtBCbarplus - NtBCbarmin;
sigdifftBCbar = sqrt(NtBCbarplus + NtBCbarmin);

testBCbarD = testBCbar&testD;
astBCbarD = (arlft(testBCbarD) - arRt(testBCbarD))./(arlft(testBCbarD) + arRt(testBCbarD));
NtBCbarDplus = length(astBCbarD(astBCbarD>0));
NtBCbarDmin = length(astBCbarD(astBCbarD<0));
NtotBCbarD = length(astBCbarD);
difftBCbarD= NtBCbarDplus - NtBCbarDmin;
sigdifftBCbarD = sqrt(NtBCbarDplus + NtBCbarDmin);

fprintf('Condition  Ntotal Nleft NRight\tDiff\n');
fprintf('Test1     :%d\t %d\t %d\t %f %c %f \n',Ntot1,Nt1plus,Nt1min,difft1,177,sigdifft1); 
fprintf('TestA     :%d\t %d\t %d\t %f %c %f \n',NtotA,NtAplus,NtAmin,difftA,177,sigdifftA); 
fprintf('TestB     :%d\t %d\t %d\t %f %c %f \n',NtotB,NtBplus,NtBmin,difftB,177,sigdifftB); 
fprintf('TestC     :%d\t %d\t %d\t %f %c %f \n',NtotC,NtCplus,NtCmin,difftC,177,sigdifftC); 
fprintf('TestD     :%d\t %d\t %d\t %f %c %f \n',NtotD,NtDplus,NtDmin,difftD,177,sigdifftD); 
fprintf('TestAB    :%d\t %d\t %d\t %f %c %f \n',NtotAB,NtABplus,NtABmin,difftAB,177,sigdifftAB); 
fprintf('TestBCbar :%d\t %d\t %d\t %f %c %f \n',NtotBCbar,NtBCbarplus,NtBCbarmin,difftBCbar,177,sigdifftBCbar); 
fprintf('TestBCbarD:%d\t %d\t %d\t %f %c %f \n',NtotBCbarD,NtBCbarDplus,NtBCbarDmin,difftBCbarD,177,sigdifftBCbarD); 


%id=17; ind1=find(erf==0&matlabday>=datenum(2011,6,id,0,0,0)&matlabday<datenum(2011,6,id+1,0,0,0));plot(xsig(ind1),ycen(ind1),'.');
%checking one day at a time worth for checking ycen and xsig

%specshow(test1,matlabday,xcen,erf,xsig,arlft,arRt,ycen)
