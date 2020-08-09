function [S, count] = cr_sol_direct_with_info(blocks, colors, l, colPos)

S = cr_sol_direct(blocks,colors,l,0);
idxKeep = true(size(S,1),1);
for i=1:size(colPos,1)
    for j=1:size(colPos,2)
        if(colPos(i,j)==0)
            idxKeep = idxKeep & (S(:,j)~=i-1);
        end
    end
end
S = S(idxKeep,:);

count = size(S,1);

end