clc

% Amplitude
model1 ='Lab_Modulation_AM';
open(model1) 
set_param('Lab_Modulation_AM/M', 'Value', '1')
save_system(model1);
simOut1 = sim('Lab_Modulation_AM', 'SaveOutput', 'on', 'SaveFormat', 'Dataset');

simOut1.yout.get(1).Values;
X1=simOut1.yout.get(1).Values.Data;
t1=simOut1.yout.get(1).Values.Time;

N1=length(X1);
fd1 = 1/(t1(2)-t1(1));

S1 = abs(fft(X1)/N1);
S1 = S1(1:N1/2);
S1(2:N1/2)=2*S1(2:N1/2);
f1=fd1*(0:1:(N1/2)-1)'/N1;
close_system


% 2 Friquency
model2 ='Lab_Modulation_FM';
open(model2) 
set_param('Lab_Modulation_FM/dW', 'Value', '50*2*pi')
set_param('Lab_Modulation_FM/FMDP', 'Kc', '50')

save_system(model2);
simOut2 = sim('Lab_Modulation_FM', 'SaveOutput', 'on', 'SaveFormat', 'Dataset');
simOut2.yout.get(1).Values;
X2=simOut2.yout.get(1).Values.Data;
t2=simOut2.yout.get(1).Values.Time;

N2=length(X2);
fd2 = 1/(t2(2)-t2(1));

S2 = abs(fft(X2)/N2);
S2 = S2(1:N2/2);
S2(2:N2/2)=2*S2(2:N2/2);
f2=fd2*(0:1:(N2/2)-1)'/N2;
close_system


% 3 Phase
model3 ='Lab_Modulation_PM';
open(model3) 
set_param('Lab_Modulation_PM/dPhi', 'Value', 'pi/2')
set_param('Lab_Modulation_PM/PMDP', 'Kc', 'pi/2')
save_system(model3);
simOut3 = sim('Lab_Modulation_PM', 'SaveOutput', 'on', 'SaveFormat', 'Dataset');

simOut3.yout.get(1).Values;
X3=simOut3.yout.get(1).Values.Data;
t3=simOut3.yout.get(1).Values.Time;

N3=length(X3);
fd3 = 1/(t3(2)-t3(1));

S3 = abs(fft(X3)/N3);
S3 = S3(1:N3/2);
S3(2:N3/2)=2*S3(2:N3/2);
f3=fd3*(0:1:(N3/2)-1)'/N3;
close_system

plot(f1, S1, f2, S2, f3, S3)
legend('AM', 'FM', 'PM');