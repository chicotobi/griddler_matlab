clc; clear; close all

arr_inp_nr = [200968 39756 147510 88712 90062 5654 22364];

p.reporting_level = 0;

for inp_nr=arr_inp_nr(5)
    for max_upper_bound=1000 %round(10.^linspace(3,6,4))
        for threshold=round(10.^linspace(3,6,20))
            for method=[1,2]
                p.inp_nr = inp_nr;
                p.method = method;
                p.min_threshold = threshold;
                p.max_upper_bound = max_upper_bound;
                solve_logical(p);
            end
        end
    end
end