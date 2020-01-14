clear all;
z=[2;3;-5];
ne=[-2,5,-1;1,3,1];
nev=[-10,12];
e=[1,1,1];
ev=[7];
x=linprog(-z,ne,nev,e,ev,zeros(3,1))