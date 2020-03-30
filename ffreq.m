function [ f ] = ffreq( x, fs, fr, dt, sq )
%
%  f = ffreq(x, fs, fr, dt)
%
%   Find frequencies in an RF waveform x
%
%   Input:
%       x -- input RF waveform
%       fs -- sampling frequency
%       fr -- frequency resolution
%       dt -- time sampling period
%       sq -- threshold value
%
%   Output:
%       f -- frequencies found in signal
%

% assume reasonable defaults
if nargin < 5,
   sq = 0.1;
end
if nargin < 4,
   dt = 0.1;
end
if nargin < 3,
    fr = 1000;
end
if nargin < 2,
    fs = 2048000;
end

% find the frame size
nf = fs/fr;

% find the number of frames to skip
nt = fs*dt;

% compute the spectrum of the first block
xf = fftshift(fft(x(1:nf))).';

% compute the next blocks, spaced by dt seconds
jj = 1;
while jj< length(x)-nf,
    xf = [xf; fftshift(fft(x(jj+(0:nf-1)))).'];
    jj = jj+nt;
end

% find the maximum signals in each frequency bin
xfm = max(abs(xf));

% find the maximimum overall, for normalization
mx = max(xfm);

% find the indexes of the frequency channels that are abouve the
% squelch threshold.  Indexes are relative to the carrier
f = find(abs(xfm)>sq*mx) - nf/2;

% convert the indexes to absolute frequencies
f = f*fr;

end