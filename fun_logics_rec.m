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

min_threshold = 1e6;
threshold = min_threshold;
while true
    created_line = 0;
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
                [~,count] = cr_sol_rec_with_info(blocks,colors,l,colPos,1);
                if(count<threshold)
                    created_line = 1;
                    posSol{ori}{line} = cr_sol_rec_with_info(blocks,colors,l,colPos,0)+1;
                    fprintf("In Ori %i Line %i created %i solutions.\n",ori,line,size(posSol{ori}{line},1));
                else
                    fprintf("In Ori %i Line %i #solutions %i bigger than threshold %i.\n",ori,line,count,threshold);
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
    if sum((colorPossible_old(:)-colorPossible(:)).^2)==0 && ~created_line
        threshold = threshold * 4;
        fprintf("Increase threshold to %i.\n",threshold);
    else
        threshold = max(min_threshold,threshold/2);
    end
    
end

end