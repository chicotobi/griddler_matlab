function [H, V, HC, VC, cmap] = translate_griddlers_net(f)

d0 = fopen(f);
s = fscanf(d0,"%s");
fclose(d0);

colors = extractBetween(s,"colors","originalColors");
colors = colors{1};
colors = eval(colors(2:end-1));
cols = zeros(numel(colors),3);
for i=1:numel(colors)
    cols(i,:) = hex2rgb(char(colors(i)));
end
    

usedColors = extractBetween(s,"usedColors","topHeader");
usedColors = usedColors{1};
usedColors = eval(usedColors(2:end-1));
usedColors = usedColors+1;
cmap = cols(usedColors,:);

dimX = extractBetween(s,"width","height");
dimX = dimX{1};
dimX = eval(dimX(2:end-1));

sV = extractBetween(s,"topHeader","leftHeader");
sV = sV{1};
sV = sV(3:end-2);
idx0=strfind(sV,"[[");
idx1=strfind(sV,"]]");
V = cell(dimX,1);
VC = cell(dimX,1);
for i=1:dimX
    tmp = eval(sV(idx0(i):idx1(i)+1));
    VC{i} = tmp(1:2:end)-1;
    V{i} = tmp(2:2:end);
end

dimY = extractBetween(s,"height","hw");
dimY = dimY{1};
dimY = eval(dimY(2:end-1));

sH = extractAfter(s,"leftHeader");
sH = sH(3:end-2);
idx0=strfind(sH,"[[");
idx1=strfind(sH,"]]");
H = cell(dimY,1);
HC = cell(dimY,1);
for i=1:dimY
    tmp = eval(sH(idx0(i):idx1(i)+1));
    HC{i} = tmp(1:2:end)-1;
    H{i} = tmp(2:2:end);
end

cmap = [str2rgb("unknown");cmap];

end