function [colorPossible, err,cmap] = fun_logics_rec(inp_nr,posSol,colorPossible,inc_level)

nColors = size(colorPossible,3);

f_str = num2str(inp_nr);
[H, V, HC, VC, ~] = translate_griddlers_net(f_str);

dimX = size(V,1);
dimY = size(H,1);
M = {H,V};
C = {HC,VC};
dim = [size(colorPossible,1) size(colorPossible,2)];

err = false;

%Indentation
ind = '';
for i=1:inc_level
    ind = strcat(ind,'--');
end

while true
    colorPossible_old = colorPossible;
    for ori=1:2
        for line=1:dim(ori)
            change = 0;
            tmp = posSol{ori}{line};
            if(class(tmp)=="string"&&tmp=="NotCreated")
                blocks = M{ori}{line};
                colors = C{ori}{line};
                l = dim(3-ori);
                colPos = squeeze(colorPossible(line,:,:))';
                try
                    posSol{ori}{line} = cr_sol_rec_with_info(blocks,colors,l,colPos)+1;
                    fprintf("In Ori %i Line %i created %i solutions.\n",ori,line,size(posSol{ori}{line},1));
                catch ME
                    fprintf("In Ori %i Line %i solution number still too big.\n",ori,line);
                    posSol{ori}{line} = "NotCreated";
                end
            else
                for color=1:nColors
                    % Update
                    tmp = posSol{ori}{line};
                    v = (sum(tmp==color,1)>0);
                    colorPossible(line,:,color) = v & colorPossible(line,:,color);
                    
                    npSol = size(posSol{ori}{line},1);
                    remove_this_solution = false(npSol,dim(3-ori),nColors);
                    colorPossibleLine = colorPossible(line,:,color);
                    for i = 1:dim(3-ori)
                        remove_this_solution(:,i,color) = (~colorPossibleLine(i)) & (posSol{ori}{line}(:,i)==color);
                    end
                    idxKeep = ~any(remove_this_solution,[2,3]);
                    if(~any(idxKeep))
                        err = true;
                        return;
                    end
                    posSol{ori}{line} = posSol{ori}{line}(idxKeep,:);
                    change = change | (sum(idxKeep)~=npSol);
                    
                    for i=1:dim(3-ori)
                        c1 = min(posSol{ori}{line}(:,i));
                        c2 = max(posSol{ori}{line}(:,i));
                        if(c1==c2)
                            for c=1:nColors
                                if(c~=c1)
                                    colorPossible(line,i,c) = 0;
                                end
                            end
                        end
                    end
                end
                if(change)
                    fprintf('%sIn Ori %i Line %i left %i solutions.\n',ind,ori,line,size(posSol{ori}{line},1));
                    if(inc_level<3)
                        scr_plot(colorPossible,posSol,ori,line)
                    end
                else
                    fprintf("In Ori %i Line %i no change.\n",ori,line);
                end
            end
        end
        colorPossible = permute(colorPossible,[2,1,3]);
    end
    
    % If solved
    if all(sum(colorPossible,3)==1,"all")
        return;
    end
    
    %Increase guess level
    if sum((colorPossible_old(:)-colorPossible(:)).^2)==0
        
        %Copy all solutions
        thPosSol = posSol;
        
        %Increase inception level
        inc_level=inc_level+1;
        
        %Now search for a line with minimal number of possible solutions
        min_s = Inf;
        for ori=1:2
            for line=1:dim(ori)
                if 1 < size(thPosSol{ori}{line},1) && size(thPosSol{ori}{line},1) < min_s
                    min_s = size(thPosSol{ori}{line},1);
                    min_idx = [ori,line];
                end
            end
        end
        
        %Now choose the first solution of this line to be correct
        thPosSol{min_idx(1),min_idx(2)} = thPosSol{min_idx(1),min_idx(2)}(1,:);
        
        %Now go deeper
        fprintf(strcat(ind,'Guess correct solution in O%iL%i of  %i solutions there.\n'),min_idx(1),min_idx(2),min_s);
        [thColorPossible, err] = fun_logics_rec(inp_nr,thPosSol, colorPossible, inc_level);
        
        %If you receive an error, the chosen solution was not the correct
        %one => delete it, and go on.
        %Otherwise the solution criterion must be hit => solved!
        if err
            fprintf(strcat(ind,'Invalid solution in O%iL%i found and dropped, remaining %i solutions.\n'),min_idx(1),min_idx(2),min_s-1);
            posSol{min_idx(1),min_idx(2)} = posSol{min_idx(1),min_idx(2)}(2:end,:);
            inc_level = inc_level - 1;
        else
            colorPossible = thColorPossible;
            fprintf(strcat(ind,'Returned from inception level %i. Solved!\n'),inc_level);
            return;
        end
    end
    
end

end