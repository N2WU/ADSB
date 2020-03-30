function decode_id(pd)

% decoding vector
dcd = '#ABCDEFGHIJKLMNOPQRSTUVWXYZ#####_###############0123456789######';

% number of packets, np, and the packet length lp
[np lp] = size(pd);

% for each packet
for jj=1:np,
    cs = [];
    % decode 7 characters 6 bits at a time
    for kk=1:6:(6*7),
        % compute the value of the next 6 bits
        nc = sum(pd(jj,kk+[40:45]).*(2.^[5:-1:0]));
	% look up the value for this 6 bits in the decode table
        cs = [cs dcd(nc+1)];
    end
    % display the result
    disp(cs)
end
