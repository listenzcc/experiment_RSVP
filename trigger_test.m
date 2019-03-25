clear all

para_id='D020';

config_io;
for i=1:10
    outp(hex2dec(para_id),i);
    WaitSecs(1);
    outp(hex2dec(para_id),0);
end