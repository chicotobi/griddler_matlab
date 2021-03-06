function rgb = str2rgb(s0)

rgb = zeros(numel(s0),3);

for i=1:numel(s0)
    switch s0(i)
        case "unknown"
            rgb(i,:) = [0.5,0.5,0.5];
        case "white"
            rgb(i,:) = [1,1,1];
        case "black"
            rgb(i,:) = [0,0,0];
        case "brown"
            rgb(i,:) = [0.5,0,0];
        case "green"
            rgb(i,:) = [0,1,0];
        case "dark green"
            rgb(i,:) = [0,0.4,0];
        case "pink"
            rgb(i,:) = [1,0,0.5];
        case "light pink"
            rgb(i,:) = [1,0.84,0.89];
    end
end
end