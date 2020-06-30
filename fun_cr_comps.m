function fun_cr_comps(noWhiteBlocks,noWhiteSquares)
noComp1 = alg_n_k(noWhiteSquares-1,noWhiteBlocks-1);
noComp2 = alg_n_k(noWhiteSquares-1,noWhiteBlocks-2);
noComp3 = alg_n_k(noWhiteSquares-1,noWhiteBlocks-3);
noComps = noComp1 + 2*noComp2 + noComp3;
fprintf('Starting (%i %i) composition, this will give %i compositions\n',noWhiteBlocks,noWhiteSquares,noComps);
tic;
count = 0;
A = zeros(noComps,noWhiteBlocks,'int8');

%Non-zero at the left, non-zero at the right
if noComp1 > 0
    n = noWhiteSquares;
    k = noWhiteBlocks;
    a = [n-k,zeros(1,k-1)];
    t = n - k;
    h = 0;
    count = count + 1; A(count,:) = a;
    for i=2:noComp1
        if ( 1 < t )
            h = 0;
        end
        h = h + 1;
        t = a(h);
        a(h) = 0;
        a(1) = t - 1;
        a(h+1) = a(h+1) + 1;
        count = count + 1; A(count,:) = a;
        if(~mod(count,100000))
            fprintf('%i of %i\n',count,noComps);
        end
    end
    A(1:count,:) = A(1:count,:) + 1;   
end

%Zero at the left, non-zero at the right OR Non-zero at the left, zero at the right
if noComp2 > 0
    n = noWhiteSquares;
    k = noWhiteBlocks-1;
    a = [n-k,zeros(1,k-1)];
    t = n - k;
    h = 0;
    count = count + 1; A(count,:) = [0,a];
    for i=2:noComp2
        if ( 1 < t )
            h = 0;
        end
        h = h + 1;
        t = a(h);
        a(h) = 0;
        a(1) = t - 1;
        a(h+1) = a(h+1)+1;
        count = count + 1; A(count,:) = [0,a];
        if(~mod(count,100000))
            fprintf('%i of %i\n',count,noComps);
        end
    end
    A(noComp1+1:count,2:end) = A(noComp1+1:count,2:end) + 1;
    count = count + noComp2;
    A(noComp1+noComp2+1:count,1:end-1) = A(noComp1+1:noComp1+noComp2,2:end);
end

%Zero at the left, zero at the right
if noComp3 > 0
    n = noWhiteSquares;
    k = noWhiteBlocks-2;
    a = [n-k,zeros(1,k-1)];
    t = n - k;
    h = 0;
    count = count + 1; A(count,:) = [0,a,0];
    for i=2:noComp3
        if ( 1 < t )
            h = 0;
        end
        h = h + 1;
        t = a(h);
        a(h) = 0;
        a(1) = t - 1;
        a(h+1) = a(h+1) + 1;
        count = count + 1; A(count,:) = [0,a,0];
        if(~mod(count,100000))
            fprintf('%i of %i\n',count,noComps);
        end
    end
    A(noComp1+2*noComp2+1:count,2:end-1) = A(noComp1+2*noComp2+1:count,2:end-1) + 1;
end

str = strcat(pwd,'/comps/comp_',num2str(noWhiteBlocks),'_',num2str(noWhiteSquares),'.mat');
save(str,'A');
toc;
fprintf('Finished (%i %i) composition\n',noWhiteBlocks,noWhiteSquares);
end