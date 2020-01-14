clear all;
% »­º¯ÊýÍ¼Ïó
[x,y]=meshgrid(-1:0.1:5);
z=(x-2).^2+4*(y-3).^2;
%mesh(x,y,z);
contour(x,y,z,20);
grid;
hold on;
% »­µã
p_nr=10;
point=[0;0;40];
for i=1:p_nr
   pre=point(1:3,i:i);
   next_x= 2*(pre(1,1)-2);
   next_y= 8*(pre(2,1)-3);
   length=sqrt(next_x.^2+next_y.^2);
   next = [next_x/length;next_y/length;0]
   next = pre - next;
   next(3,1)= (next(1,1)-2).^2+4*(next(2,1)-3).^2
   point=[point next];
end
plot(point(1,:),point(2,:),'r.');
%plot3(point(1,:),point(2,:),point(3,:),'r.');