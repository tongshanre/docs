clear all;
%生成数据点
titles={'原始点'};
N=10;
noise_sigma=0.08;
x=rand(10,1);
y=sin(2*pi*x)+randn(10,1)*noise_sigma;
scatter(x,y);
hold
%拟合数据
for M=2:1:5
    X=[];
    for x1 = x
       row=[];
       for i=0:1:M %生成行数据
         row=[row x1.^i];
       end
       X=[X;row];
    end    
    T=y;
    W=inv((X'*X))*X'*T;
    %画曲线
    var=0:0.01:1;
    y_var=zeros(size(var));
    for i=0:1:M
       y_var=y_var+(W(i+1,1)*var.^i);
    end
    plot(var,y_var);
    titles{size(titles,2)+1}=strcat('M=',num2str(M));
end
legend(titles);