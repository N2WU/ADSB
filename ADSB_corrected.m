%{
1. find preambles and spikes: signal is 1090 MHz only
2. matched filter with conv[(u = signal (rake)), (v = filter / preamble
backwards)
2a. one bit = 4 samples, drag past end of signal
3. take 32 samples x elements of matched filter (should see tight spikes
where preamble is)
4. plot(conv), threshold
5. double match conv(), this time with identifier bit [0 0 1 0 0]
6. it should work??
%}

da = abs(loadFile('adsb_3.2M_3.dat'));
d = resample(da,5,4);

PreambleVector = [1 1 0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0];
PreambleAdj = flip(PreambleVector);

IdentifierVector = [0 0 1 0 0];

w = conv(d, PreambleAdj);
%w = w > 100; %threshold

ICAO = [];
NewData = [];
ID = [];
NewID = [];

for n = 1:length(w) 
    if w(n) > 200 %if the current bit is ~definitely~ a preamble
        clear RawDataPacket;
        RawDataPacket = d(n:end); %get a chunk of the data
        RawDataPacket = RawDataPacket > 20; %Threshold
        DataPacket = RawDataPacket((find(RawDataPacket, 1)+8*4):(find(RawDataPacket,1)+120*4)); %Packet that is 4x the needed length
        DataPacket = DataPacket(1:2:end); %take every other bit
        %DataVector = [];
        DataPacketAdj = DataPacket(1:2:end); %Sample the second time; should be logic
        if isempty(DataPacketAdj) == 0 %Don't use illogical empty packets
            if DataPacketAdj(33:37) == IdentifierVector %if data packets line up with identifier vector
                NewData = decode_id(DataPacketAdj) %decode the correct binary information
                ID = [ID ; NewData]; %add it to an array
            end
            NewID = binaryVectorToHex(DataPacketAdj(9:32).');
                if NewID ~= [0 0 0 0 0 0] %ignore empty values
                    ICAO = [ICAO ; NewID]; %save ICAO addresses into an array
                end
        end
    end
end
