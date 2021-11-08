function solve_logical(p)

% Parameters
threshold = p.min_threshold;
iter = 0;

% Creation
tic;
f_str = num2str(p.inp_nr);
[H, V, HC, VC, cmap] = translate_griddlers_net(f_str);
M = {H,V};
C = {HC,VC};
dim = [size(H,1),size(V,1)];
posSol = cell(2,1);
for ori=1:2
    posSol{ori} = cell(dim(ori),1);
    for line=1:dim(ori)
        blocks = M{ori}{line};
        colors = C{ori}{line};
        l = dim(3-ori);
        [~,count] = cr_sol_direct(blocks,colors,l,1);
        if(count < threshold)
            posSol{ori}{line} = cr_sol_direct(blocks,colors,l,0)+1;
            if(p.reporting_level>0)
                fprintf('O%iL%i created with %i solutions.\n',ori,line,count);
            end
        else
            posSol{ori}{line} = num2str(count);
            if(p.reporting_level>0)
                fprintf("O%iL%i not created with %i solutions.\n",ori,line,count);
            end
        end
    end
end
nColors = size(cmap,1)-1;
colorPossible = true(dim(1),dim(2),nColors);
t = toc;
f1 = fopen("results.csv","a");
fprintf(f1,"%i,%i,%i,%i,%i,%f\n",p.inp_nr,p.method,p.min_threshold,p.max_upper_bound,iter,t);
fclose(f1);

% Solution
last = 0;
while true
    tic;
    if(p.reporting_level>0)
        plot_progress(colorPossible,posSol,cmap,iter,threshold,1,0);
    end
    iter = iter + 1;
    created_line = 0;
    colorPossible_old = colorPossible;
    for ori=1:2
        for line=1:dim(ori)
            created_this_line = 0;
            change = 0;
            tmp = posSol{ori}{line};
            if(isa(tmp,'char'))
                blocks = M{ori}{line};
                colors = C{ori}{line};
                l = dim(3-ori);
                colPos = squeeze(colorPossible(line,:,:))';
                [~,count] = cr_sol_rec_with_info(blocks,colors,l,colPos,1,p);
                if(count < threshold)
                    created_line = 1;
                    created_this_line = 1;
                    posSol{ori}{line} = cr_sol_rec_with_info(blocks,colors,l,colPos,0,p)+1;
                    if(p.reporting_level>0)
                        fprintf("O%iL%i created with %i solutions.\n",ori,line,count);
                    end
                else
                    posSol{ori}{line} = num2str(count);
                    if(p.reporting_level>0)
                        fprintf("O%iL%i not created with %i solutions. Threshold %i.\n",ori,line,count,threshold);
                    end
                end
            end
            if(~isa(tmp,'char'))
                for color=1:nColors
                    % Update
                    tmp = posSol{ori}{line};
                    v = (sum(tmp==color,1)>0);
                    colorPossible(line,:,color) = v & colorPossible(line,:,color);
                    
                    npSol = size(posSol{ori}{line},1);
                    remove_this_solution = false(npSol,dim(3-ori));
                    colorPossibleLine = colorPossible(line,:,color);
                    tmp1 = (posSol{ori}{line}==color);
                    for i = 1:dim(3-ori)
                        remove_this_solution(:,i) = (~colorPossibleLine(i)) & tmp1(:,i);
                    end
                    idxKeep = ~any(remove_this_solution,2);
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
                if(p.reporting_level>0 && change)
                    fprintf('O%iL%i left %i solutions.\n',ori,line,size(posSol{ori}{line},1));
                end
                if(p.reporting_level>1 && (change || created_this_line))
                    plot_progress(colorPossible,posSol,cmap,iter,threshold,ori,line);
                end
            end
        end
        colorPossible = permute(colorPossible,[2,1,3]);
    end
    
    % If solved
    if all(sum(colorPossible,3)==1,"all")
        if(last==1)
            if(p.reporting_level>0)
                plot_progress(colorPossible,posSol,cmap,iter,threshold,1,-1);
            end
            break;
        end
        last = 1;
    end
    
    % What happens if there is no change?
    if(p.method==1)
        % Increase threshold
        if sum((colorPossible_old(:)-colorPossible(:)).^2)==0 && ~created_line
            threshold = threshold * 4;
            fprintf("Increase threshold to %i.\n",threshold);
        else
            threshold = max(p.min_threshold,threshold/2);
        end
    else
        % Create the solution with the least number of possibilities
        if sum((colorPossible_old(:)-colorPossible(:)).^2)==0 && ~created_line
            n0 = Inf;
            for it_ori=1:2
                for it_line=1:dim(it_ori)
                    tmp = posSol{it_ori}{it_line};
                    if(isa(tmp,'char'))
                        n = str2double(tmp);
                        if(n<n0)
                            n0 = n;
                            ori = it_ori;
                            line = it_line;
                        end
                    end
                end
            end
            blocks = M{ori}{line};
            colors = C{ori}{line};
            l = dim(3-ori);
            if(ori==1)
                colPos = squeeze(colorPossible(line,:,:))';
            else
                colPos = squeeze(colorPossible(:,line,:))';
            end
            posSol{ori}{line} = cr_sol_rec_with_info(blocks,colors,l,colPos,0,p)+1;
            if(p.reporting_level>0)
                fprintf("O%iL%i created with %i solutions.\n",ori,line,count);
            end
        end
    end
    t = toc;
    f1 = fopen("results.csv","a");
    fprintf(f1,"%i,%i,%i,%i,%i,%f\n",p.inp_nr,p.method,p.min_threshold,p.max_upper_bound,iter,t);
    fclose(f1);
end

% Add a dummy line to confirm that the function finished correctly
f1 = fopen("results.csv","a");
fprintf(f1,"%i,%i,%i,%i,%i,%f\n",p.inp_nr,p.method,p.min_threshold,p.max_upper_bound,-1,0);
fclose(f1);
fprintf("Finished p=(%i,%i,%i,%i)\n",p.inp_nr,p.method,p.min_threshold,p.max_upper_bound);

end
