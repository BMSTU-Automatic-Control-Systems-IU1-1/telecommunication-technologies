clc
clear variables
close all force

table = readtable('data.txt');

A1 = 15.1;
A2 = 9.675;

freq1 = 0;
freq2 = 250;

w2 = 2 * pi * freq2;

h = 0.00005;
T=1;

t = table{:, 1};
X = table{:, 2};
X2 = 2 * A2 * sin(w2 * t) + A1;

figure 
plot(t, X, t, X2)

N=length(X);
F = zeros(2, T/h+1);
a = zeros(1, T/h+1);
A = zeros(1, T/h+1);

fdiskr=1/h;

func=zeros(1, T/h+1);

for k=1:N
    for n=1:N
        F(1, k)=F(1, k)+X(n)*(cos( (2*pi*(k-1)*(n-1))/(N-1) ));
        F(2, k)=F(2, k)+X(n)*(sin( (2*pi*(k-1)*(n-1))/(N-1) ));
    end
    A(k) = sqrt(F(1, k)^2+F(2, k)^2)/N;
    alpha = atan( (F(1, k)) /( F(2, k) ));
end

k = 0:N-1;
f=(fdiskr * k)/N;

figure()
plot(f, A)
