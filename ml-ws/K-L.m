clear all;
x1=[0 1 1 1];
y1=[0 0 0 1];
z1=[0 0 1 0];
plot3(x1,y1,z1,'b.','MarkerSize',20);
x2=[0 0 0 1];
y2=[0 1 1 1];
z2=[1 0 1 1];
hold on;
plot3(x2,y2,z2,'r.','MarkerSize',20);
grid;
%----------------1ά--------
clear all;
w1_o=[0 1 1 1;0 0 0 1; 0 0 1 0];
w2_o=[0 0 0 1;0 1 1 1;1 0 1 1];
a=[1/2 1/2 sqrt(2)/2];
w1_n=a*w1_o;
w2_n=a*w2_o;
plot(w1_n,[0 0 0 0],'o');
hold on;
plot(w2_n,zeros(1,4),'+')
%-----------------2ά------
clear all;
w1_o=[0 1 1 1;0 0 0 1; 0 0 1 0];
w2_o=[0 0 0 1;0 1 1 1;1 0 1 1];
a=[1/2 1/2 sqrt(2)/2;sqrt(2)/2 -sqrt(2)/2 0];
w1_n=a*w1_o
w2_n=a*w2_o
x1=w1_n(1:1,:);
y1=w1_n(2:2,:);
x2=w2_n(1:1,:);
y2=w2_n(2:2,:);
plot(x1,y1,'o');
hold on;
plot(x2,y2,'+');

