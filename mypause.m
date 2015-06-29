function mypause

figure('KeyPressFcn',@(obj,evt) 0);

waitfor(gcf,'CurrentCharacter');
curChar=uint8(get(gcf,'CurrentCharacter'));
