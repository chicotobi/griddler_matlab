clear; close; clc;
black = [1 2];
l = 6;

ninp = numel(black);
nwhites = l - sum(black);
nfreewhites = nwhites - (ninp-1);
k = ninp;
n = nfreewhites + k;
a = [nfreewhites,zeros(1,ninp)];
t = 0;
h = 0;
nrows = alg_n_k(n,k);

S = zeros(nrows,l);
for j=1:nrows
    idx = 1+a(1);
    for i=1:ninp
        S(j,idx:idx+black(i)-1)=1;
        idx = idx + black(i) + 1 + a(i+1);
    end
    
    if(j==nrows)
        break;
    end
    if ( 1 < t )
        h = 0;
    end
    h = h + 1;
    t = a(h);
    a(h) = 0;
    a(1) = t - 1;
    a(h+1) = a(h+1) + 1;
end