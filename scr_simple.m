clc; clear; close all

arr_inp_nr = [200968 39756 147510 88712 90062 5654 22364];

p.inp_nr = arr_inp_nr(1);
p.more_plots = 1;
p.min_threshold = 1000;
p.max_upper_bound = 1000;
solve_logical(p);