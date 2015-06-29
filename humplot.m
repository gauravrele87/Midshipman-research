err = zeros (0,1);
md = zeros(0,1);
for year = 2011:2014
  for month = 1:12
    cstryear = num2str(year);

    infiletff = strcat('/usr/local/data3/rtc/tff/',cstryear,'/rtc',cstryear(3:4),sprintf('%02d',month),'00.tff');
    infidtf=fopen(infiletff,'r');
    if infidtf == -1
    	continue;
    end
    npttf1=fread(infidtf,1,'int32'); 
    waterdaytf1 =fread(infidtf,npttf1,'float32');
    fcentf1=fread(infidtf,npttf1,'float32');
    sigftf1=fread(infidtf,npttf1,'float32');
    s2ntf1=fread(infidtf,npttf1,'float32');
    pwrtf1=fread(infidtf,npttf1,'float32');
    pdbtf1=fread(infidtf,npttf1,'float32');
    erftf1=fread(infidtf,npttf1,'int32');
    matlabday = datenum(year,1,1,0,0,0) + waterdaytf1;
    err = [err; erftf1];
    md = [md;matlabday];
  end
end


plot(md,err,'.')

ylim([0 2.5])
