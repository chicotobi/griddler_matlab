clear;
blocks = [1 3 3];
colors = [3 1 2];
l = 7;
colPos = [ 1   0   1   1   0   1   0
   1   1   1   1   1   0   0
   0   1   1   1   1   1   1
   1   0   1   0   1   1   0
   1   1   1   1   1   1   1];

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