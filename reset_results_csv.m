function reset_results_csv()

f1 = fopen("results.csv","w");
fprintf(f1,"p.inp_nr,p.method,p.min_threshold,p.max_upper_bound,iter,t\n");
fclose(f1);

end