clc
clf

inp_nr = 22364;

%Create solution line files
tic;
fprintf('Creation started!\n');
[sol,solSet,posSol] = fun_cr_sols(num2str(inp_nr));
fprintf('Creation finished!\n');
toc;

%Run recursion
tic;
fprintf('Iteration started!\n');
[sol, err] = fun_logics_rec(sol,solSet,inp_nr,0,posSol);
fprintf('Iteration finished!\n');
toc;

%Plot solution
solSet = true | sol;
scr_plot