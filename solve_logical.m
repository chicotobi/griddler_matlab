function solve_logical(p)

% Parameters
threshold = p.min_threshold;
iter = 0;

% Creation
tic;
fprintf("\nIteration %i\n",iter);
f_str = num2str(p.inp_nr);
[H, V, HC, VC, cmap] = translate_griddlers_net(f_str);
M = {H,V};
C = {HC,VC};
dim = [size(H,1),size(V,1)];
posSol = cell(2,1);
status = cell(2,1);
for ori=1:2
    posSol{ori} = cell(dim(ori),1);
    status{ori} = cell(dim(ori),1);
    for line=1:dim(ori)
        blocks = M{ori}{line};
        colors = C{ori}{line};
        l = dim(3-ori);
        [~,count] = cr_sol_direct(blocks,colors,l,1);
        if(count < threshold)
            posSol{ori}{line} = cr_sol_direct(blocks,colors,l,0)+1;
            status{ori}{line} = [line count 1];
            if(p.verbose)
                fprintf('O%iL%03d %s - created.\n',ori,line,prty(count));
            end
        else
            status{ori}{line} = [line count 0];
            if(p.verbose)
                fprintf("O%iL%03d %s - not created.\n",ori,line,prty(count));
            end
        end
    end
end
nColors = size(cmap,1)-1;
colorPossible = true(dim(1),dim(2),nColors);

% % If the color is not even present in the colors, it can directly be
% % removed - without knowing the order
for ori=1:2
    for line=1:dim(ori)
        for c=1:(nColors-1)
            if all(C{ori}{line}~=c)
                colorPossible(line,:,c+1) = false;
            end
        end
    end
    colorPossible = permute(colorPossible,[2,1,3]);
end

t = toc;
f1 = fopen("results.csv","a");
fprintf(f1,"%i,%i,%i,%i,%f\n",p.inp_nr,p.min_threshold,p.max_upper_bound,iter,t);
fclose(f1);

% Solution
last = 0;
while true
    tic;
    if(p.verbose)
        plot_progress(colorPossible,status,cmap,iter,threshold,1,0);
    end
    iter = iter + 1;
    fprintf("\nIteration %i\n",iter);
    created_line = 0;
    colorPossible_old = colorPossible;
    for ori=1:2
        for line=1:dim(ori)
            if(status{ori}{line}(3)==1)
                n_old = size(posSol{ori}{line},1);
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
                n_new = size(posSol{ori}{line},1);
                if(p.verbose && (n_new<n_old))
                    fprintf('O%iL%03d %s - was %s.\n',ori,line,prty(n_new),prty(n_old));
                    plot_progress(colorPossible,status,cmap,iter,threshold,ori,line);
                end
            end
        end
        colorPossible = permute(colorPossible,[2,1,3]);
    end

    % If solved
    if all(sum(colorPossible,3)==1,"all")
        if(last==1)
            if(p.verbose)
                plot_progress(colorPossible,status,cmap,iter,threshold,1,-1);
            end
            break;
        end
        last = 1;
    end

    % What happens if there is no change?
    if sum((colorPossible_old(:)-colorPossible(:)).^2)==0
        % Update the solution numbers
        created_line = false;
        vals = [];
        for ori=1:2
            for line=1:dim(ori)
                if(status{ori}{line}(3)==0)
                    blocks = M{ori}{line};
                    colors = C{ori}{line};
                    l = dim(3-ori);
                    if(ori==1)
                        colPos = squeeze(colorPossible(line,:,:))';
                    else
                        colPos = squeeze(colorPossible(:,line,:))';
                    end
                    [~,count] = cr_sol_rec_with_info(blocks,colors,l,colPos,1,p);
                    if(count < threshold)
                        created_line = true;
                        posSol{ori}{line} = cr_sol_rec_with_info(blocks,colors,l,colPos,0,p)+1;
                        status{ori}{line} = [line count 1];
                        if(p.verbose)
                            fprintf("O%iL%03d %s - created by threshold.\n",ori,line,prty(count));
                        end
                    else
                        vals = [vals;ori line count];
                    end
                end
            end
        end
        % If no new line is created, choose some with smallest count
        if ~created_line
            vals = sortrows(vals,3);
            nline = min(3,size(vals,1));
            for i=1:nline
                ori = vals(i,1);
                line = vals(i,2);
                blocks = M{ori}{line};
                colors = C{ori}{line};
                l = dim(3-ori);
                if(ori==1)
                    colPos = squeeze(colorPossible(line,:,:))';
                else
                    colPos = squeeze(colorPossible(:,line,:))';
                end
                posSol{ori}{line} = cr_sol_rec_with_info(blocks,colors,l,colPos,0,p) + 1;
                if(p.verbose)
                    fprintf("O%iL%03d %s - created by force.\n",ori,line,prty(vals(i,3)));
                end
            end
        end
    end
    t = toc;
    f1 = fopen("results.csv","a");
    fprintf(f1,"%i,%i,%i,%i,%f\n",p.inp_nr,p.min_threshold,p.max_upper_bound,iter,t);
    fclose(f1);
end

% Add a dummy line to confirm that the function finished correctly
f1 = fopen("results.csv","a");
fprintf(f1,"%i,%i,%i,%i,%f\n",p.inp_nr,p.min_threshold,p.max_upper_bound,-1,0);
fclose(f1);
fprintf("Finished p=(%i,%i,%i)\n",p.inp_nr,p.min_threshold,p.max_upper_bound);

end
