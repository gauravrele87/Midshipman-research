load /home/toad/project/1410/rtc/ship/gaurav/lfsc143.mat
 
lfnswplus = mod(tlfnsw + datenum(0,0,0,7,20,0),1);
lfnswminus = lfnswplus - datenum(0,0,0,0,6,0);
%lfnswminus = mod(tlfnsw + datenum(0,0,0,7,14,0),1);

lfnshplus = mod(tlfnsh + datenum(0,0,0,7,20,0),1);
lfnshminus = mod(tlfnsh + datenum(0,0,0,7,14,0),1);

lfsnwplus = mod(tlfsnw + datenum(0,0,0,7,16,0),1);
lfsnwminus = lfsnwplus - datenum(0,0,0,0,6,0);
%lfsnwminus = mod(tlfsnw + datenum(0,0,0,7,10,0),1);

lfsnshplus = mod(tlfsnh + datenum(0,0,0,7,16,0),1);
lfsnhminus = mod(tlfsnh + datenum(0,0,0,7,10,0),1);


testf = false(npt,1);
ind = [];
testNS = false(npt,1);
testSN = false(npt,1);
for i = 1: length(tlfnsw)
   ind1=find ( lfnswplus(i) > hour & hour> lfnswminus(i));
   ind2=find(lfsnwplus(i) > hour & hour> lfsnwminus(i));
   for j = 1:length(ind1)
     testf(ind1(j))=1;
     testNS(ind1(j))=1;
   end
   for j=1:length(ind2)
     testf(ind2(j))=1;
     testSN(ind2(j))=1;
   end
end
  
