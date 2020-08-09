clear;

for i=1:1000
    nblocks = randi(4);
    ncolors = randi(4)+1;
    l = randi(10);
    blocks = randi(6,1,nblocks);
    colors = randi(ncolors-1,1,nblocks);
    colPos = rand(ncolors,l)>0.2;
    
    % solver one for testing
    S1 = cr_sol_direct_with_info(blocks,colors,l,colPos);
    S1 = sortrows(S1);
    
    % solver two
    [S2, count] = cr_sol_rec_with_info(blocks,colors,l,colPos, 0);
    S2 = sortrows(S2);
    
    if(size(S1,1)==size(S2,1))
        if all(S1(:)==S2(:))
            if(count==size(S2,1))
                fprintf("Pass\n")
            else
                fprintf("Row count fail\n")
                count
                size(S2,1)
                return
            end
        else
            blocks
            colors
            l
            colPos
            fprintf("Fail\n")
            return
        end
    else
        blocks
        colors
        l
        colPos
        fprintf("Fail\n")
        return
    end
end