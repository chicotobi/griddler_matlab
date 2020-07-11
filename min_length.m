function l = min_length(blocks,colors)

l = sum(blocks)+sum(diff(colors)==0);

end