function S = cr_sol_direct(blocks, colors, l)

ninp = numel(blocks);
nwhites = l - sum(blocks);
next_block_is_same_color = [diff(colors)==0, 0];

nfreewhites = nwhites - sum(next_block_is_same_color);
k = ninp;
n = nfreewhites + k;
a = [nfreewhites,zeros(1,ninp)];
t = 0;
h = 0;
nrows = alg_n_k(n,k);
if(nrows>1e5)
    throw(MException("cr_sol_direct:solutionTooBig"))
end

tell = 10000;

S = zeros(nrows,l,"uint8");
for j=1:nrows
    idx = 1+a(1);
    for i=1:ninp
        S(j,idx:idx+blocks(i)-1) = colors(i);
        idx = idx + blocks(i) + next_block_is_same_color(i) + a(i+1);
    end
    if(j==nrows)
        break;
    end
    if(mod(j,tell)==0)
        fprintf('\tshifting... %i of %i compositions\n',j,nrows);
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

end