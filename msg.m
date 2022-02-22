function msg(p,ori,line,count,txt)

if(p.verbose)
    fprintf('O%iL%03d %s - %s.\n',ori,line,prty(count),txt);
end

end