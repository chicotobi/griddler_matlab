function s2 = prty(x)

if x>=1e15
    s2 = '           too large';
else
    s = [repmat(' ',1,15-length(num2str(x))) num2str(x)];
    p = '.';
    s2 = [s(1:3) p s(4:6) p s(7:9) p s(10:12) p s(13:15)];
end

end