function [sol, err] = fun_logics_rec(sol,solSet,inp_nr,inc_lev,posSol)

err = false;

dim = [size(sol,1),size(sol,2)];
solSet_old = true(dim(1),dim(2));

%Indentation
ind = '';
for i=1:inc_lev
    ind = strcat(ind,'--');
end

while true
    solSetChange = and(solSet,not(solSet_old));
    solSet_old = solSet;
    sol_old = sol;
    %Deleting solutions
    for ori=1:2
        for line=1:dim(ori)
            if any(solSetChange(line,:))
                npSol = size(posSol{ori,line},1);
                mat = false(npSol,dim(3-ori));
                solLine = sol(line,:);
                solSetLine = solSet(line,:);
                for i = 1:dim(3-ori)
                    mat(:,i) = solSetLine(i) & xor(solLine(i),posSol{ori,line}(:,i));
                end
                idxKeep = ~any(mat,2);
                if(~any(idxKeep))
                    err = true;
                    return;
                end
                posSol{ori,line} = posSol{ori,line}(idxKeep,:);
                %fprintf('In Ori %i Line %i, deleted %i of former %i solutions. Left %i solutions.\n',ori,line,npSol-sum(idxKeep),npSol,sum(idxKeep));
            else
                %fprintf('In Ori %i Line %i, no deletion this iteration tried.\n',ori,line);
            end
            
            v1 = all(posSol{ori,line},1);
            sol(line,v1) = true;
            solSet(line,v1) = true;
            v2 = ~any(posSol{ori,line},1);
            sol(line,v2) = false;
            solSet(line,v2) = true;
            
        end
        sol = sol';
        solSet = solSet';
        solSetChange = solSetChange';
        %solSetChange = and(solSet,not(solSet_old'));
        %solSet_old = solSet;
    end
    
    if all(solSet)
        return;
    end
    
    %Plot
    scr_plot;
    
    %Increase guess level
    if norm(sol_old-sol)==0
        
        %Copy all solutions
        thPosSol = posSol;
        
        %Increase inception level
        inc_lev=inc_lev+1;
        
        %Now search for a line with minimal number of possible solutions
        min_s = Inf;
        for ori=1:2
            for line=1:dim(ori)
                if 1 < size(thPosSol{ori,line},1) && size(thPosSol{ori,line},1) < min_s
                    min_s = size(thPosSol{ori,line},1);
                    min_idx = [ori,line];
                end
            end
        end
        
        %Now choose the first solution of this line to be correct
        thPosSol{min_idx(1),min_idx(2)} = thPosSol{min_idx(1),min_idx(2)}(1,:);
        
        %Now go deeper
        fprintf(strcat(ind,'Guess correct solution in O%iL%i of  %i solutions there.\n'),min_idx(1),min_idx(2),min_s);
        [thSol, err] = fun_logics_rec(sol,solSet,inp_nr,inc_lev,thPosSol);
        
        %If you receive an error, the chosen solution was not the correct
        %one => delete it, and go on.
        %Otherwise the solution criterion must be hit => solved!
        if err
            fprintf(strcat(ind,'Invalid solution in O%iL%i found and dropped, remaining %i solutions.\n'),min_idx(1),min_idx(2),min_s-1);
            posSol{min_idx(1),min_idx(2)} = posSol{min_idx(1),min_idx(2)}(2:end,:);
            inc_lev = inc_lev - 1;
        else
            sol = thSol;
            fprintf(strcat(ind,'Returned from inception level %i. Solved!\n'),inc_lev);
            return;
        end
    end
    
end

end