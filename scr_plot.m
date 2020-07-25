function scr_plot(colorPossible,posSol,ori,ll)
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

subplot(2,2,[1,3])
imagesc(sol,[0,nColors]);
colormap(cmap);
hold on
if(ori==1)
    line([0.5,dim(2)+0.5],[ll,ll],"LineWidth",2,"Color","black")
else
    line([ll,ll],[0.5,dim(1)+0.5],"LineWidth",2,"Color","black")
end
axis([0.5,dim(2)+0.5,0.5,dim(1)+0.5]);
set(gca,'xTick',[]);
set(gca,'yTick',[]);
axis equal
axis tight
grid on

subplot(2,2,2)
xx=zeros(dim(1),1);
mark = [];
for i=1:dim(1)
    v = posSol{1}{i};
    if(isa(v,'char'))
        xx(i) = str2double(v);
        mark = [mark;i, xx(i)];
    else
        xx(i) = size(v,1);
    end
end
semilogy(xx,'-x');
hold on
if(size(mark,1)>0)
    semilogy(mark(:,1),mark(:,2),'ro');
end
xlim([0 dim(1)])
xlabel("Horizontal lines")
ylim([0 1e10])

subplot(2,2,4)
xx=zeros(dim(2),1);
mark = [];
for i=1:dim(2)
    v = posSol{2}{i};
    if(isa(v,'char'))
        xx(i) = str2double(v);
        mark = [mark;i, xx(i)];
    else
        xx(i) = size(v,1);
    end
end
semilogy(xx,'-x');
hold on
if(size(mark,1)>0)
    semilogy(mark(:,1),mark(:,2),'ro');
end
xlim([0 dim(2)])
xlabel("Vertical lines")
ylim([0 1e10])

drawnow

end