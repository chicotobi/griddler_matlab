rm(list=ls())
library(tidyverse)
library(metR)
d <- read.csv("~/griddler_matlab/results.csv")
d$p.inp_nr <- factor(d$p.inp_nr,levels = c(200968,39756,147510,88712,90062,5654,22364))

# Only get finished combinations
d <- d %>% filter(iter>=0)

d2 <- d %>%
  group_by(p.inp_nr,p.method,p.min_threshold,p.max_upper_bound) %>% summarize(t=sum(t)) %>% ungroup()
d2 %>% ggplot(aes(p.min_threshold,t,col=factor(p.max_upper_bound),shape=factor(p.method),lty=factor(p.method))) +
  geom_line() + geom_point() + scale_x_log10() + facet_wrap(~p.inp_nr,scales = "free")

d %>% ggplot(aes(iter,t,col=factor(p.min_threshold))) + geom_smooth(se=F, method="loess",span=2) + facet_wrap(~p.inp_nr+p.method,scales="free") +
  scale_y_log10()

d %>% ggplot(aes(iter,t,col=factor(p.min_threshold))) + geom_line() + facet_wrap(~p.inp_nr+p.method,scales="free") +
  scale_y_log10()

# For contours
e <- read.csv("~/griddler_matlab/results.csv") %>%
  mutate(p.max_upper_bound=p.max_upper_bound+1) %>%
  mutate(log_min_treshold=log(p.min_threshold),log_max_upper_bound=log(p.max_upper_bound))
e %>% ggplot(aes(p.min_threshold,p.max_upper_bound,z=t)) + 
  geom_contour(breaks=seq(1,40)) + geom_label_contour(skip = 0) + scale_x_log10() + scale_y_log10() + facet_wrap(~p.inp_nr,scales="free")
