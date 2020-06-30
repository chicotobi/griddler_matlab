function [sol,solSet,posSol] = fun_cr_sols(f_str)

str = strcat('inp_',f_str);
run(str);
tell = 10000;
dimX = size(V,1);
dimY = size(H,1);
M = {H,V};
dim = [dimX,dimY];
posSol = cell(2,max(dimX,dimY));
sol = false(dimY,dimX);
solSet = false(dimY,dimX);

for ori=1:2
    for line=1:dim(3-ori)
        str1 = strcat(pwd,'/sols/',f_str,'/ori',num2str(ori),'_line',num2str(line),'.mat');
        if ~exist(str1,'file')
            black = M{ori}{line};
            noWhiteBlocks = length(black) + 1;
            noWhiteSquares = dim(ori) - sum(black);
            str2 = strcat(pwd,'/comps/comp_',num2str(noWhiteBlocks),'_',num2str(noWhiteSquares),'.mat');
            if ~exist(str2,'file')
                fun_cr_comps(noWhiteBlocks,noWhiteSquares);
            end
            noComps = alg_n_k(noWhiteSquares-1,noWhiteBlocks-1)+2*alg_n_k(noWhiteSquares-1,noWhiteBlocks-2)+alg_n_k(noWhiteSquares-1,noWhiteBlocks-3);
            S = false(noComps,dim(ori));
            fprintf('Creating sol O%iL%i, loading (%i %i) combination with %i compositions.\n',ori,line,noWhiteBlocks,noWhiteSquares,noComps);
            load(str2,'A');
            for k=1:size(A,1)
                pos = 1 + A(k,1);
                for l=1:length(black)
                    S(k,pos:(pos+black(l)-1))=true;
                    pos = pos + black(l) + A(k,l+1);
                end
                if(mod(k,tell)==0)
                    fprintf('\tshifting... %i of %i compositions\n',k,noComps);
                end
            end
            fprintf('\tFinished sol O%iL%i, using (%i %i) combination with %i compositions.\n',ori,line,noWhiteBlocks,noWhiteSquares,noComps);            
            save(str1,'S','-v7.3');
        end      
    end
end

for ori=1:2
    for line=1:dim(3-ori)
        line
        str1 = strcat(pwd,'/sols/',f_str,'/ori',num2str(ori),'_line',num2str(line),'.mat');
        load(str1,'S');
        posSol{ori,line} = S;       
    end
end

end