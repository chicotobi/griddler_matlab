clc; clear; close all

%inp_nr = 200968;
inp_nr = 147510;
%inp_nr = 39756;
%inp_nr = 88712;
%inp_nr = 22364;
%inp_nr = 5654;
%inp_nr = 90062;

global cmap iter
iter = 0;
% Creation
tic;
fprintf('Creation started!\n');
[posSol, colorPossible, cmap] = fun_cr_sols(inp_nr);
fprintf('Creation finished!\n');
toc;

% Recursion
tic;
fprintf('Iteration started!\n');
colorPossible = fun_logics_rec(inp_nr, posSol, colorPossible, 0);
fprintf('Iteration finished!\n');
toc;

% Final plot
scr_plot(colorPossible,posSol,1,0);