clc; clear; close all

arr_inp_nr = [200968 39756 147510 88712 90062 5654 22364];
arr_max_upper_bound = 1000;
arr_min_threshold = round(10.^linspace(3,6,4));

p.inp_nr = arr_inp_nr(4);
p.more_plots = 0;

f1 = fopen("results.csv","a");
%fprintf(f1,"p.inp_nr,p.min_threshold,p.max_upper_bound,t\n");
for i=1:numel(arr_min_threshold)
    for j=1:numel(arr_max_upper_bound)
        p.min_threshold = arr_min_threshold(i);
        p.max_upper_bound = arr_max_upper_bound(j);
        tic;
        solve_logical(p);
        t = toc;
        fprintf(f1,"%i,%i,%i,%f\n",p.inp_nr,p.min_threshold,p.max_upper_bound,t);     
    end
end
fclose(f1);