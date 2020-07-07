function translate_griddlers_net(f)

run("test.m")
H = cell(numel(leftHeader),1);
HC = cell(numel(leftHeader),1);
for i=1:numel(leftHeader)
    tmp = leftHeader{i};
    H{i} = zeros(1,numel(tmp));
    HC{i} = zeros(1,numel(tmp));
    for j=1:numel(tmp)
        HC{i}(j) = tmp{j}{1} - 1;
        H{i}(j) = tmp{j}{2};
    end
end
V = cell(numel(topHeader),1);
VC = cell(numel(topHeader),1);
for i=1:numel(topHeader)
    tmp = topHeader{i};
    V{i} = zeros(1,numel(tmp));
    VC{i} = zeros(1,numel(tmp));
    for j=1:numel(tmp)
        VC{i}(j) = tmp{j}{1} - 1;
        V{i}(j) = tmp{j}{2};
    end
end
cols = strings(numel(colors),1);
for i=1:numel(colors)
    cols(i) = colors{i}{1};
end

end