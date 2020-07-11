clear all;close;clc;

% input
blocks = [1     3     1     1     2     1     2     3     2     2];
colors = [1     2     1     2     3     1     2     4     3     2];
l = 34;
%blocks = [2 3 4];
%colors = [1 2 2];
%l = 13;


% output 1
S = cr_sol_direct(blocks, colors, l) + 1;

% output 2
%S2 = cr_sol_rec(blocks, colors, l) +1 ;
%~any(any(sortrows(S)-sortrows(S2)))