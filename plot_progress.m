function plot_progress(colorPossible,status,cmap,iter,threshold,ori,ll)
clf

% Preparation
nColors = size(colorPossible,3);
if(ori==1)
    dim = [size(colorPossible,1),size(colorPossible,2)];
    tmp = colorPossible;
else
    dim = [size(colorPossible,2),size(colorPossible,1)];
    tmp = permute(colorPossible,[2,1,3]);
end
dims = size(tmp);
sol = zeros(dims(1),dims(2));
for i=1:dims(1)
    for j=1:dims(2)
        if(sum(tmp(i,j,:))==1)
            sol(i,j) = find(tmp(i,j,:));
        end
    end
end

% Plot
if(ll>-1)
    subplot(2,2,[1,3])
end
imagesc(sol,[0,nColors]);
colormap(cmap);
hold on
if(ll>0)
    if(ori==1)
        line([0.5,dim(2)+0.5],[ll,ll],"LineWidth",2,"Color","black")
    else
        line([ll,ll],[0.5,dim(1)+0.5],"LineWidth",2,"Color","black")
    end
end
axis([0.5,dim(2)+0.5,0.5,dim(1)+0.5]);
set(gca,'xTick',[]);
set(gca,'yTick',[]);
axis equal
axis tight
grid on
title(append("Iteration ",num2str(iter)))

if(ll>-1)
    subplot(2,2,2)
    xx=zeros(dim(1),1);
    mark = [];
    for i=1:dim(1)
        xx(i) = status{1}{i}(2);
        if(status{1}{i}(3) == 0)
            mark = [mark;i, xx(i)];
        end
    end
    semilogy(xx,'-x');
    hold on
    if(ori==1)
        xline(ll)
    end
    if(size(mark,1)>0)
        semilogy(mark(:,1),mark(:,2),'ro');
    end
    line([1 dim(1)],[threshold threshold],"Color","red")
    xlim([1 dim(1)])
    xlabel("Horizontal lines")
    up = max(10,ceil(log10(max(xx))));
    ylim([1 10^up])
    
    subplot(2,2,4)
    xx=zeros(dim(2),1);
    mark = [];
    for i=1:dim(2)
        xx(i) = status{2}{i}(2);
        if(status{2}{i}(3) == 0)
            mark = [mark;i, xx(i)];
        end
    end
    semilogy(xx,'-x');
    hold on
    if(ori==2)
        xline(ll)
    end
    if(size(mark,1)>0)
        semilogy(mark(:,1),mark(:,2),'ro');
    end
    line([1 dim(2)],[threshold threshold],"Color","red")
    xlim([1 dim(2)])
    xlabel("Vertical lines")
    up = max(10,ceil(log10(max(xx))));
    ylim([1 10^up])
end

drawnow

end