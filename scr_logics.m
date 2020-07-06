clc; clear; close all

inp_nr = 42;

% Creation
tic;
fprintf('Creation started!\n');
[posSol, colorPossible] = fun_cr_sols(inp_nr);
fprintf('Creation finished!\n');
toc;

% Recursion
tic;
fprintf('Iteration started!\n');
colorPossible = fun_logics_rec(posSol, colorPossible, 0);
fprintf('Iteration finished!\n');
toc;

% Final plot
scr_plot(colorPossible,posSol,1,0);