function S = cr_sol_rec(blocks, colors, l)

ml = min_length(blocks,colors);
if(ml<=l)
    b = blocks(1);
    c = colors(1);
    if(numel(blocks)==1)
        S = zeros(l-b+1,l,"uint8");
        for i=1:l-b+1
            S(i,i:i+b-1) = c;
        end
    else
        blocks = blocks(2:end);
        colors = colors(2:end);
        if(c==colors(1))
            k = l - min_length(blocks,colors) - b - 1;
        else
            k = l - min_length(blocks,colors) - b;
        end
        S = [];
        for i=0:k
            if(c==colors(1))
                tmp = [zeros(1,i,"uint8") ones(1,b,"uint8")*c 0];
                S0 = cr_sol_rec(blocks,colors,l-i-b-1);
            else
                tmp = [zeros(1,i,"uint8") ones(1,b,"uint8")*c];
                S0 = cr_sol_rec(blocks,colors,l-i-b);
            end
            S = [S;repmat(tmp,size(S0,1),1) S0];
        end
    end
else
    S = [];
end

end