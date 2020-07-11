function S = cr_sol_rec_with_info(blocks, colors, l, colPos)

if(numel(blocks)==0)
    S = zeros(1,l,"uint8");
    return;
end

if(l<min_length(blocks,colors))
    S = [];
    return;
end

tmp = sum(colPos);
if(min(tmp)==size(colPos,1))
    S = cr_sol_direct(blocks,colors,l);
    return
end

idx = find(tmp==min(tmp));
[~,minidx] = min(abs(idx-l/2));
idx = idx(minidx);

ncol = size(colPos,1);
S = [];
for col=1:ncol
    if(colPos(col,idx)==1)
        if(col==1)
            % white
            lcolPos = colPos(:,1:idx-1);
            rcolPos = colPos(:,idx+1:end);
            for i=0:numel(blocks)
                llength = idx - 1;
                lblocks = blocks(1:i);
                lcolors = colors(1:i);
                rlength = l - idx;
                rblocks = blocks(i+1:end);
                rcolors = colors(i+1:end);
                Sl = cr_sol_rec_with_info(lblocks,lcolors,llength,lcolPos);
                Sm = 0;
                Sr = cr_sol_rec_with_info(rblocks,rcolors,rlength,rcolPos);
                if(size(Sl,1)>0 && size(Sr,1)>0)
                    [tmp0,tmp1,tmp2] = ndgrid(1:size(Sl,1),1,1:size(Sr,1));
                    S0 = [Sl(tmp0,:),Sm(tmp1,:),Sr(tmp2,:)];
                    S = [S;S0];
                end
            end
        else
            % search all blocks with this color
            [~,idx2] = find(colors==col-1);
            for i=1:numel(idx2)
                b = blocks(idx2(i));
                c = colors(idx2(i));
                lblocks = blocks(1:idx2(i)-1);
                lcolors = colors(1:idx2(i)-1);
                rblocks = blocks(idx2(i)+1:end);
                rcolors = colors(idx2(i)+1:end);
                for j=1:b
                    lsame = (numel(lcolors)>0 && lcolors(end)==c);
                    rsame = (numel(rcolors)>0 && rcolors(1)==c);
                    llength = idx-j - lsame;
                    rlength = l-idx+j-b - rsame;
                    Sl = cr_sol_rec_with_info(lblocks,lcolors,llength,lcolPos);
                    Sm = ones(1,b,"uint8")*c;
                    Sr = cr_sol_rec_with_info(rblocks,rcolors,rlength,rcolPos);
                    if(size(Sl,1)>0 && size(Sr,1)>0)
                        if(lsame)
                            Sl = [Sl zeros(size(Sl,1),1,"uint8")];
                        end
                        if(rsame)
                            Sr = [zeros(size(Sl,1),1,"uint8") Sr];
                        end
                        [tmp0,tmp1,tmp2] = ndgrid(1:size(Sl,1),1,1:size(Sr,1));
                        S0 = [Sl(tmp0,:),Sm(tmp1,:),Sr(tmp2,:)];
                        S = [S;S0];
                    end
                end
            end
        end
    end
end

end