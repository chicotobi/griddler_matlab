clear;
blocks = [2 2 3 3];
colors = [1 2 1 1];
colPos = [
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1;
    1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1
    ];
l = size(colPos,2);

S1 = cr_sol_direct(blocks,colors,l);
S2 = cr_sol_rec_with_info(blocks,colors,l,colPos);