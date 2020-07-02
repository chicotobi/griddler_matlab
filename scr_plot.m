clf
subplot(1,2,1)
sol_p = uint8(sol);
sol_p(~solSet) = 2;
imagesc(sol_p,[0,2]);
colormap([1,1,1;0,0,0;1,0,1]);
axis([0.5,size(sol,2)+0.5,0.5,size(sol,1)+0.5]);
set(gca,'xTick',0.5:(size(sol,2)+0.5));
set(gca,'yTick',0.5:(size(sol,1)+0.5));
set(gca,'xTickLabel',[]);
set(gca,'yTickLabel',[]);
grid on

subplot(1,2,2)
xx=zeros(dim(1)+dim(2),1);
for line=1:dim(1)
    xx(line) = size(posSol{1,line},1);
end
for line=1:dim(2)
    xx(dim(1)+line) = size(posSol{2,line},1);
end
plot(log(xx)/log(10),'-x');
ylim([0 10])

drawnow