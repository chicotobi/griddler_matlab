clc; clear; close all

inp_nr = 200968;
%inp_nr = 147510;
%inp_nr = 39756;
%inp_nr = 88712;
%inp_nr = 90062;
%inp_nr = 5654;
%inp_nr = 22364;

p.max_upper_bound = 1e3;
p.min_threshold = 1e6;

tic;
solve_logical(inp_nr,p,0);
toc;