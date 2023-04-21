clc

%
% laboratory № 3
%


% 2.1
polynom = [1, 0, 0, 1, 1];

crcGenerator = comm.CRCGenerator(polynom, "ChecksumsPerFrame", 1);
crcDetector  = comm.CRCDetector(polynom, "ChecksumsPerFrame", 1);

% 2.2
number_tmp = de2bi(46, 8, "left-msb")';
k = length(number_tmp);

% 2.3
number_encoded = step(crcGenerator, number_tmp);
n = length(number_encoded);
number = zeros(n, 1);
number(1 : k) = number_tmp;
izb = n - k;

% 2.4
error_decimal = 32;
error_binary = de2bi(error_decimal, length(number_encoded), "left-msb");

number_encoded_with_error = bitxor(number_encoded', error_binary);

decoded_with_error = step(crcDetector, number_encoded_with_error');

% 2.5
disp(['Кодовый полином: ', num2str(polynom)]);
disp(['Кодируемое сообщение: ', num2str(number')]);
disp(['Кодируемое сообщение (в десятичной сс): ', num2str(46)]);

[~, r] = gfdeconv(wrev(number'), wrev(polynom));
ostdel = wrev(r);
disp(['Остаток от деления кодируемого сообщения на кодовый полином: ', num2str(ostdel)]);
disp(['Закодированное сообщение: ', num2str(number_encoded')]);
disp(['Модель ошибки: ', num2str(error_binary)]);
disp(['Полученное приемником сообщение: ', num2str(number_encoded_with_error)]);
disp(['Декодированное сообщение: ', num2str(decoded_with_error')]);

% 2.6
s_x_2 = zeros(n, izb);
error_decimal = 1;
e_x = cell(n, 1);
s_x = cell(n, 1);

% 2.7
for i = 1 : n
    error_decimal = 2^(i-1);
    error_binary = de2bi(error_decimal, length(number_encoded), "left-msb");
    number_encoded_with_error = bitxor(number_encoded', error_binary);
    [~, syndrome] = gfdeconv(wrev(number_encoded_with_error), wrev(polynom));
    if length(syndrome) < izb
        syndrome(length(syndrome) + 1 : izb) = 0;
    end
    s_x_2(i, :) = wrev(syndrome);
    e_x {i} = strcat('x^', num2str(i - 1));
    str='';
    cnt = 0;
    for j = 1 : izb
        if s_x_2(i, j) ~= 0
            cnt = cnt + 1;
            cnt_limit=sum(s_x_2(i, :));
            if cnt ~= cnt_limit
                str = strcat(str, string(strcat('x^', num2str(izb - j), '+')));
            else
                str = strcat(str + string(strcat('x^', num2str(izb - j))));
            end
            s_x{i}=str;
        end
    end
end

table(e_x, s_x, s_x_2)

% 3.1
p = 1;
for i = 2 : length(number_tmp)
    p=bitxor(number_tmp(i), p);
end


number_tmp(1)=p;
disp(['Исходное сообщение с битом чётности в старшем бите: ', num2str(number_tmp')]);
crcDetector = comm.CRCDetector(polynom, "ChecksumsPerFrame", 1);

number_encoded_with_error=bitxor(number_encoded', error_binary);
[~, error] = step(crcDetector, number_encoded_with_error');

% 3.2
disp(['Проверка достоверности передачи (1 - есть ошибка, 0 - нет ошибки): ', num2str(error)]);

errors_binary=2^3+2^5;
errors_binary=de2bi(errors_binary, n, "left-msb");
number_encoded_with_errors=bitxor(number_encoded', errors_binary);

% 3.3
[~, error] = step(crcDetector, number_encoded_with_errors');
disp(['Проверка достоверности передачи (1 - есть ошибка, 0 - нет ошибки): ', num2str(error)]);



