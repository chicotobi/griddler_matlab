function [posSol, colorPossible, cmap] = fun_cr_sols(inp_nr)

f_str = num2str(inp_nr);
[H, V, HC, VC, cmap] = translate_griddlers_net(f_str);

tell = 10000;
dimX = size(V,1);
dimY = size(H,1);
M = {H,V};
C = {HC,VC};
dim = [dimX,dimY];

for ori=1:2
    for line=1:dim(3-ori)
        str1 = strcat(pwd,'/sols/',f_str,'/ori',num2str(ori),'_line',num2str(line),'.mat');
        if ~exist(strcat(pwd,"/sols"),"dir")
            mkdir(strcat(pwd,"/sols"))
        end
        if ~exist(strcat(pwd,"/sols/",f_str),"dir")
            mkdir(strcat(pwd,"/sols/",f_str))
        end
        if ~exist(str1,'file')
            blocks = M{ori}{line};
            colors = C{ori}{line};
            
            ninp = numel(blocks);
            nwhites = dim(ori) - sum(blocks);
            next_block_is_same_color = [diff(colors)==0, 0];
            
            nfreewhites = nwhites - sum(next_block_is_same_color);
            k = ninp;
            n = nfreewhites + k;
            a = [nfreewhites,zeros(1,ninp)];
            t = 0;
            h = 0;
            nrows = alg_n_k(n,k);
            
            S = ones(nrows,dim(ori),"uint8");
            for j=1:nrows
                idx = 1+a(1);
                for i=1:ninp
                    S(j,idx:idx+blocks(i)-1) = colors(i) + 1;
                    idx = idx + blocks(i) + next_block_is_same_color(i) + a(i+1);
                end
                if(mod(j,tell)==0)
                    fprintf('\tshifting... %i of %i compositions\n',j,nrows);
                end
                if(j==nrows)
                    break;
                end
                if ( 1 < t )
                    h = 0;
                end
                h = h + 1;
                t = a(h);
                a(h) = 0;
                a(1) = t - 1;
                a(h+1) = a(h+1) + 1;
            end
            fprintf('\tFinished sol O%iL%i.\n',ori,line);
            save(str1,'S','-v7.3');
        end
    end
end

posSol = cell(2,max(dimX,dimY));
for ori=1:2
    for line=1:dim(3-ori)
        str1 = strcat(pwd,'/sols/',f_str,'/ori',num2str(ori),'_line',num2str(line),'.mat');
        load(str1,'S');
        posSol{ori,line} = S;
    end
end

nColors = size(cmap,1)-1;
colorPossible = true(dimY,dimX,nColors);

end