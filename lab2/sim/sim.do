
#set PathSeparator .

set WLFFilename waveform.wlf
log -r /*
log -r tb_top/dut/arm/dp/rf/rf

run -all
quit
