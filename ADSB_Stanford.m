da = abs(loadFile('adsb_3.2M.dat'));
d = resample(da,5,4);


%This is an example using a pre-selected set of data. It takes a chunk of
%d, called x, and thresholds it above 3. I chose 3 by looking at the graph.
%Then, y is the actual packet with preamble removed. Y is 4 times the ideal
%packet length (112) due to the sampling rate. I then downsample it in z by
%taking every other packet. I should use logic for g, but I got lazy and
%took another sample. G is my 112 (113 for some reason) bit packet. I
%convert the ICAO (bits 9:32) to hex and get a value.
plot(d(1:1e6));

tiledlayout('flow')

nexttile
x = d(8.150e5:8.156e5);% import signal, found on website
plot(x);

x = x > 3;
find(x,1)

y = x((find(x, 1)+8*4):(find(x,1)+120*4));
nexttile
stem(y);

z = y(1:2:end);
nexttile
stem(z);

g = z(1:2:end);

ICAO = binaryVectorToHex(g(9:32).')



