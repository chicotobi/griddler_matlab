function [S, count] = cr_sol_rec_with_info(blocks, colors, l, colPos, onlycount, p)

if(~onlycount)
    [~, upper_bound] = cr_sol_direct(blocks,colors,l,1);
    if(upper_bound < p.max_upper_bound)
        [S, count] = cr_sol_direct_with_info(blocks,colors,l,colPos);
        return;
    end
end

S = [];
count = 0;
if(numel(blocks)==0 && l>=0)
    if(all(colPos(1,:)==1) || l==0)
        count = 1;
        S = zeros(1,l,"uint8");
    end
    return;
end

if(l<min_length(blocks,colors))
    return;
end

tmp = sum(colPos);
if(min(tmp)==size(colPos,1))
    [S,count] = cr_sol_direct(blocks,colors,l,onlycount);
    return
end

idx = find(tmp==min(tmp));
[~,minidx] = min(abs(idx-l/2));
idx = idx(minidx);

ncol = size(colPos,1);
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
                [Sl, countl] = cr_sol_rec_with_info(lblocks,lcolors,llength,lcolPos, onlycount,p);
                [Sr, countr] = cr_sol_rec_with_info(rblocks,rcolors,rlength,rcolPos, onlycount,p);
                count = count + countl * countr;
                if(~onlycount && countl>0 && countr>0)
                    idxl = repmat((1:countl)',countr,1);
                    idxr = reshape(repmat((1:countr),countl,1),[],1);
                    S0 = [Sl(idxl,:),zeros(countl*countr,1,'uint8'),Sr(idxr,:)];
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
                % shift the middle block left and right
                % left blocks go from 1 to idx-j, shortened by lsame
                % middle block goes from idx-j+1 to idx-j+b
                % right blocks go from idx-j+b+1 to l, shortened by rsame
                for j=1:b
                    % now check if the shifting middle block is hitting the
                    % sides
                    if(idx-j+1<1 || idx-j+b>l)
                        continue
                    end
                    % now check if the middle block can even sit there
                    if(any(colPos(c+1,idx-j+1:idx-j+b)==0))
                        continue
                    end
                    lsame = (numel(lcolors)>0 && lcolors(end)==c);
                    if(numel(lblocks)>0 && (idx-j<1 || (lsame && colPos(1,idx-j)==0)))
                        continue
                    end
                    rsame = (numel(rcolors)>0 && rcolors(1)==c);
                    if(numel(rblocks)>0 && (idx-j+b+1>l || (rsame && colPos(1,idx-j+b+1)==0)))
                        continue
                    end
                    llength = idx-j - lsame;
                    rlength = l-idx+j-b - rsame;
                    if(llength>=0 && rlength>=0 && llength<=size(colPos,2) && rlength<=size(colPos,2))
                        lcolPos = colPos(:,1:llength);
                        rcolPos = colPos(:,end-rlength+1:end);
                        [Sl,countl] = cr_sol_rec_with_info(lblocks,lcolors,llength,lcolPos,onlycount,p);
                        [Sr,countr] = cr_sol_rec_with_info(rblocks,rcolors,rlength,rcolPos,onlycount,p);
                        count = count + countl * countr;
                        if(~onlycount)
                            if(countl>0 && countr>0)
                                Sm = ones(countl*countr,b,'uint8')*c;
                                if(lsame)
                                    Sm = [zeros(countl*countr,1,"uint8") Sm];
                                end
                                if(rsame)
                                    Sm = [Sm zeros(countl*countr,1,"uint8")];
                                end
                                idxl = repmat((1:countl)',countr,1);
                                idxr = reshape(repmat((1:countr),countl,1),[],1);
                                S0 = [Sl(idxl,:),Sm,Sr(idxr,:)];
                                S = [S;S0];
                            end
                        end
                    end
                end
            end
        end
    end
end

end