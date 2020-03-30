da = abs(loadFile('adsb_3.2M.dat'));
da = da(1:1e6); %Just take a small amount of the data to start

d = resample(da,5,4);

%squelch
w = conv(d, ones(1,128));
w = w(1:length(d));
idx = w > 200;

%Find start and end of where we break squelch
num_packets = 0;
packet_starts = {};
for ii = 1:length(d)
    if idx(ii) == 0
        continue;
    end
    
    if idx(ii) == 1
        if (ii ~= 1) && ( idx(ii - 1) == 0 )
            num_packets = num_packets + 1;
            packet_starts{num_packets} = ii;
        else
            continue
        end
    end
end

%break into packets
packets = {};
for ii = 1:length(packet_starts)
    if packet_starts{ii} < 128
        pstart = 1;
    else
        pstart = packet_starts{ii} - 128;
    end
    if packet_starts{ii} > length(d) - 480
        pend = length(d);
    else
        pend = packet_starts{ii} + 480;
    end
    packets{ii} = d(pstart:pend);
end

for ii = 1:length(packets)
    p = packets{ii};
    %threshold each packet
    thresh = mean(p)*1.1;
    p = p > thresh;
    
    %cut-off all blank space at start
    p = p( find(p,1):end );
    
    %m = 2*mask(1:length(p))-1;
    
    packets{ii} = p;
end