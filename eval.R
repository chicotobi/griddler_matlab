library(tidyverse)
library(metR)
d <- read.csv("~/griddler_matlab/results.csv") %>%
  mutate(p.max_upper_bound=p.max_upper_bound+1) %>%
  mutate(log_min_treshold=log(p.min_threshold),log_max_upper_bound=log(p.max_upper_bound))

d %>% ggplot(aes(p.min_threshold,p.max_upper_bound,z=t)) + 
  geom_contour(breaks=seq(1,40)) + geom_label_contour(skip = 0) + scale_x_log10() + scale_y_log10() + facet_wrap(~p.inp_nr,scales="free")
