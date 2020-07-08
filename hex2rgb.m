function rgb = hex2rgb(shex)
rgb = [hex2dec(shex(1:2)) hex2dec(shex(3:4)) hex2dec(shex(5:6))]/255;
end