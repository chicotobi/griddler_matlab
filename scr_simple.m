clc; clear; close all

arr_inp_nr = [
    5654   %  50 x 44 - Tiger
    22364  %  50 x 50 - Cheetah (Bicolor Version)
    39756  %  35 x 25 - Beautiful Eye
    88712  %  45 x 45 - Lion
    90062  %  40 x 30 - Eruption
    108636 %  33 x 32 - Purple Pansy
    146877 %  29 x 23 - VW Bug
    147510 %  23 x 34 - Blue Pansy
    156449 %  19 x 29 - Pansy Flower
    185213 %  70 x 75 - From Fairy Tale to Fairytale - Castle
    189138 %  70 x 70 - Sailing
    200968 %  15 x 20 - Pink Flower
    202082 % 100 x 60 - Japanese Landscape
    202358 %  30 x 30 - Maple leaf
    ];

p.inp_nr = arr_inp_nr(3);
p.min_threshold = 1e6;
p.max_upper_bound = 1000;
p.verbose = true;
solve_logical(p);