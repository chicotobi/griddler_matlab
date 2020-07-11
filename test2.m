clear;

for i=1:1000
    nblocks = randi(4);
    ncolors = randi(4)+1;
    l = randi(10);
    blocks = randi(6,1,nblocks);
    colors = randi(ncolors-1,1,nblocks);
    colPos = rand(ncolors,l)>0.2;
    
    % solver one for testing
    S1 = cr_sol_direct(blocks,colors,l);
    for i=1:size(colPos,1)
        for j=1:size(colPos,2)
            if(colPos(i,j)==0)
                idxKeep = S1(:,j)~=i-1;
                S1 = S1(idxKeep,:);
            end
        end
    end
    S1 = sortrows(S1);
    
    % solver two
    S2 = cr_sol_rec_with_info(blocks,colors,l,colPos);
    S2 = sortrows(S2);
    
    if(size(S1,1)==size(S2,1))
        if all(S1(:)==S2(:))
            fprintf("Pass\n")
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