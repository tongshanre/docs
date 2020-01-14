clear all;
% 初始两类的概率
p=[1/2 1/2];
% 初始两类的坐标
x1=[0 2 2 0;
    0 0 2 2];
x2=[4 6 6 4;
    4 4 6 6];
% 计算判别平面
% 1.求均值
min_x1=sum(x1,2)/size(x1,2);
min_x2=sum(x2,2)/size(x2,2);
% 2.求协方差
sum1=zeros(2,2);
for i=1:size(x1,2)
   sum1=sum1+(x1(:,i)-min_x1)*(x1(:,i)-min_x1)'; 
end
sum1=sum1/size(x1,2);
sum2=zeros(2,2);
for i=1:size(x2,2)
   sum2=sum2+(x2(:,i)-min_x2)*(x2(:,i)-min_x2)'; 
end
sum2=sum2/size(x2,2);
% 3. 求判别界面
x=0:0.1:6;
y=6-x;

% 画图
hold;
scatter(x1(1,:),x1(2,:),'g');
scatter(x2(1,:),x2(2,:),'r');
plot(x,y);
% 判别
data=[3;4]
out=data(1,1)+data(2,1)-6;
scatter(data(1,1),data(2,1),'b');
