clc; clear; close all

arr_inp_nr = [200968 39756 147510 88712 90062 5654 22364];

p.inp_nr = 88712;
p.more_plots = 0;
p.min_threshold = 1e6;
p.max_upper_bound = 1000;
p.method = 2;
p.verbose = true;
solve_logical(p);