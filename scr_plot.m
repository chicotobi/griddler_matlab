clf

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

unknown_color = [1,0,1];
white = [1,1,1];
black = [0,0,0];
mycmap = [unknown_color;white;black];

subplot(2,2,[1,3])
sol_p = uint8(sol);
solSet = sum(tmp,3)==1;
imagesc(sol_p,[0,nColors]);
colormap(mycmap);
hold on
if(ori==1)
    builtin("line",[0.5,dim(2)+0.5],[line,line],"LineWidth",2,"Color","black")
else
    builtin("line",[line,line],[0.5,dim(1)+0.5],"LineWidth",2,"Color","black")
end
axis([0.5,dim(2)+0.5,0.5,dim(1)+0.5]);
set(gca,'xTick',0.5:dim(2)+0.5);
set(gca,'yTick',0.5:dim(1)+0.5);
set(gca,'xTickLabel',[]);
set(gca,'yTickLabel',[]);
grid on

subplot(2,2,2)
xx=zeros(dim(1),1);
for line=1:dim(1)
    xx(line) = size(posSol{1,line},1);
end
plot(log(xx)/log(10),'-x');
xlim([0 dim(1)])
ylim([0 10])

subplot(2,2,4)
xx=zeros(dim(2),1);
for line=1:dim(2)
    xx(line) = size(posSol{2,line},1);
end
plot(log(xx)/log(10),'-x');
xlim([0 dim(2)])
ylim([0 10])

drawnow