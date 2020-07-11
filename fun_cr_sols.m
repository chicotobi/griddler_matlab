function [posSol, colorPossible, cmap] = fun_cr_sols(inp_nr)

f_str = num2str(inp_nr);
[H, V, HC, VC, cmap] = translate_griddlers_net(f_str);

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
            l = dim(ori);
            method = 1;
            try
                if(method==1)
                    S = cr_sol_direct(blocks,colors,l)+1;
                else
                    S = cr_sol_rec(blocks,colors,l)+1;
                end
                fprintf('\tFinished sol O%iL%i.\n',ori,line);
            catch ME
                fprintf("\tDid not create O%iL%i.\n",ori,line)
                S = "NotCreated";
            end
            save(str1,'S','-v7.3');
        end
    end
end

posSol = cell(2,1);
for ori=1:2
    posSol{ori} = cell(dim(3-ori),1);
    for line=1:dim(3-ori)
        str1 = strcat(pwd,'/sols/',f_str,'/ori',num2str(ori),'_line',num2str(line),'.mat');
        load(str1,'S');
        posSol{ori}{line} = S;
    end
end

nColors = size(cmap,1)-1;
colorPossible = true(dimY,dimX,nColors);

end