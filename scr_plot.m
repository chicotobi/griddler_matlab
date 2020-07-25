function scr_plot(colorPossible,posSol,ori,line)
clf
global cmap

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

if(line>0)
    subplot(2,2,[1,3])
end
imagesc(sol,[0,nColors]);
colormap(cmap);
hold on
if(ori==1)
    builtin("line",[0.5,dim(2)+0.5],[line,line],"LineWidth",2,"Color","black")
else
    builtin("line",[line,line],[0.5,dim(1)+0.5],"LineWidth",2,"Color","black")
end
axis([0.5,dim(2)+0.5,0.5,dim(1)+0.5]);
set(gca,'xTick',[]);
set(gca,'yTick',[]);
axis equal
axis tight
grid on

if(line>0)
    subplot(2,2,2)
    xx=zeros(dim(1),1);
    for line=1:dim(1)
        xx(line) = size(posSol{1}{line},1);
        if(class(posSol{1}{line})=="string")
            xx(line) = 1e10;
        end
    end
    semilogy(xx,'-x');
    xlim([0 dim(1)])
    xlabel("Horizontal lines")
    ylim([0 1e10])
    
    subplot(2,2,4)
    xx=zeros(dim(2),1);
    for line=1:dim(2)
        xx(line) = size(posSol{2}{line},1);
        if(class(posSol{2}{line})=="string")
            xx(line) = 1e10;
        end
    end
    semilogy(xx,'-x');
    xlim([0 dim(2)])
    xlabel("Vertical lines")
    ylim([0 1e10])
end
drawnow

end