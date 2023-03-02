A1 = 20;
A2 = 10;
F1 = 10;
F2 = 100;
N = 100;

T = 0:0.001:0.1 - 0.001

X = A1 * sin(2 * pi * F1 * T) + A2 * sin(2 * pi * F2 * T);

Real = zeros(1, N);
Im = zeros(1, N);


for k = 1 : N 
    for n = 1 : N 
        Real(k) = Real(k) + X(n) * cos(2 * pi * (k-1) * (n-1) / N);
        Im(k) = Im(k) - X(n) * sin(2 * pi * (k-1) * (n-1) / N);
    end
end

amplitude = 2 * sqrt(Real .^ 2 + Im .^ 2) / N;
range = 0:1:99;
freq = (1 / 0.001) * range / N;

% figure
% plot(freq(1:50), amplitude(1:50));




filname = 'data.txt'
table = readtable(filname);
data = table2array(table);
[amplitudePeak, peakIndex] = max(A(2:length(A)));
freq = F(peakIndex);
phase = P(peakIndex);

T = 0:0.00001:1;

signal = A(1) / 2 + amplitudePeak * sin(2 * pi * freq * T + phase);
figure
plot(data(1, :), data(2, :), data(3, :));

