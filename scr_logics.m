clc; clear; close all

arr_inp_nr = [200968 39756 147510 88712 90062 5654 22364];
arr_max_upper_bound = 1000;
arr_min_threshold = round(10.^linspace(3,6,4));

p.inp_nr = arr_inp_nr(4);
p.more_plots = 0;
p.method = 1;

for i=1:numel(arr_min_threshold)
    for j=1:numel(arr_max_upper_bound)
        p.min_threshold = arr_min_threshold(i);
        p.max_upper_bound = arr_max_upper_bound(j);
        solve_logical(p);
    end
end
fclose(f1);