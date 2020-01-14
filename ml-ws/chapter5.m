clear all;
%�������ݵ�
titles={'ԭʼ��'};
N=10;
noise_sigma=0.08;
x=rand(10,1);
y=sin(2*pi*x)+randn(10,1)*noise_sigma;
scatter(x,y);
hold
%�������
for M=2:1:5
    X=[];
    for x1 = x
       row=[];
       for i=0:1:M %����������
         row=[row x1.^i];
       end
       X=[X;row];
    end    
    T=y;
    W=inv((X'*X))*X'*T;
    %������
    var=0:0.01:1;
    y_var=zeros(size(var));
    for i=0:1:M
       y_var=y_var+(W(i+1,1)*var.^i);
    end
    plot(var,y_var);
    titles{size(titles,2)+1}=strcat('M=',num2str(M));
end
legend(titles);