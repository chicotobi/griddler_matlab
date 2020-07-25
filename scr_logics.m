clc; clear; close all

%inp_nr = 200968;
inp_nr = 147510;
%inp_nr = 39756;
%inp_nr = 88712;
%inp_nr = 22364;
%inp_nr = 5654;
%inp_nr = 90062;

global cmap iter
iter = 0;
% Creation
tic;


f_str = num2str(inp_nr);
[H, V, HC, VC, cmap] = translate_griddlers_net(f_str);

dimX = size(V,1);
dimY = size(H,1);
M = {H,V};
C = {HC,VC};
dim = [dimX,dimY];

threshold = 1e6;

posSol = cell(2,1);
for ori=1:2
    posSol{ori} = cell(dim(3-ori),1);
    for line=1:dim(3-ori)
        blocks = M{ori}{line};
        colors = C{ori}{line};
        l = dim(ori);
        [~,count] = cr_sol_direct(blocks,colors,l,1);
        if(count<threshold)
            S = cr_sol_direct(blocks,colors,l)+1;
            fprintf('O%iL%i created with %i solutions.\n',ori,line,count);
        else
            S = num2str(count);
            fprintf("O%iL%i not created with %i solutions.\n",ori,line,count);
        end
        posSol{ori}{line} = S;
    end
end

nColors = size(cmap,1)-1;
colorPossible = true(dimY,dimX,nColors);

nColors = size(colorPossible,3);

f_str = num2str(inp_nr);
[H, V, HC, VC, ~] = translate_griddlers_net(f_str);

M = {H,V};
C = {HC,VC};
dim = [size(colorPossible,1) size(colorPossible,2)];

min_threshold = 1e6;
threshold = min_threshold;
while true
    created_line = 0;
    colorPossible_old = colorPossible;
    for ori=1:2
        for line=1:dim(ori)
            change = 0;
            tmp = posSol{ori}{line};
            if(isa(tmp,'char'))
                blocks = M{ori}{line};
                colors = C{ori}{line};
                l = dim(3-ori);
                colPos = squeeze(colorPossible(line,:,:))';
                [~,count] = cr_sol_rec_with_info(blocks,colors,l,colPos,1);
                if(count<threshold)
                    created_line = 1;
                    posSol{ori}{line} = cr_sol_rec_with_info(blocks,colors,l,colPos)+1;
                    fprintf("O%iL%i created with %i solutions.\n",ori,line,count);
                else
                    posSol{ori}{line} = num2str(count);
                    fprintf("O%iL%i not created with %i solutions. Threshold %i.\n",ori,line,count,threshold);
                end
            end
            if(~isa(tmp,'char'))
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
                    fprintf('O%iL%i left %i solutions.\n',ori,line,size(posSol{ori}{line},1));
                else
                    fprintf("O%iL%i no change.\n",ori,line);
                end
            end
        end
        colorPossible = permute(colorPossible,[2,1,3]);
    end
    scr_plot(colorPossible,posSol,1,0);
    
    % If solved
    if all(sum(colorPossible,3)==1,"all")
        break;
    end
    
    %Increase guess level
    if sum((colorPossible_old(:)-colorPossible(:)).^2)==0 && ~created_line
        threshold = threshold * 4;
        fprintf("Increase threshold to %i.\n",threshold);
    else
        threshold = max(min_threshold,threshold/2);
    end
    
end

toc;

% Final plot
scr_plot(colorPossible,posSol,1,0);