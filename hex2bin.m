function b = hex2bin(s)

bta = [0 0 0 0; 0 0 0 1; 0 0 1 0; 0 0 1 1;
       0 1 0 0; 0 1 0 1; 0 1 1 0; 0 1 1 1;
       1 0 0 0; 1 0 0 1; 1 0 1 0; 1 0 1 1;
       1 1 0 0; 1 1 0 1; 1 1 1 0; 1 1 1 1];

b = [];
for jj=1:length(s),
    kk = sscanf(s(jj),'%x');
    b = [b bta(kk+1,:)];
end
end