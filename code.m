filename1 = 'climbing_down_pocket.csv';
filename2 = 'lift_with_stops_pocket.csv';
filename3 = 'jogging_hand_bhatia.csv';
filename4 = 'running_apoorv.csv';
filename5 = 'BUS.csv';


M1 = csvread(filename1);
M2 = csvread(filename2);
M3 = csvread(filename3);
M4 = csvread(filename4);
M5 = csvread(filename5);


x1 = M1(:,1);
y1 = M1(:,2);
z1 = M1(:,3);
t1 = M1(:,5);
figure;
mag1 = sqrt(x1.^2 + y1.^2 + z1.^2);
subplot(2,1,1);
plot(t1,mag1);
title('Descending Down Stairs');
xlabel('Time (ms)');
ylabel('Acceleration (0.01m/s^2)');
subplot(2,1,2);
spectrogram(mag1,120,60,512,'yaxis');

x2 = M2(:,1);
y2 = M2(:,2);
z2 = M2(:,3);
t2 = M2(:,5);
figure;
mag2 = sqrt(x2.^2 + y2.^2 + z2.^2);
subplot(2,1,1);
plot(t2,mag2);
xlabel('Time (ms)');
ylabel('Acceleration (0.01m/s^2)');
title('Elevator Going Up');
subplot(2,1,2);
spectrogram(mag2,120,60,512,'yaxis');



x3 = M3(:,1);
y3 = M3(:,2);
z3 = M3(:,3);
t3 = M3(:,5);
figure;
mag3 = sqrt(x3.^2 + y3.^2 + z3.^2);
subplot(2,1,1);
plot(t3,mag3);
xlabel('Time (ms)');
ylabel('Acceleration (0.01m/s^2)');
title('Jogging');
subplot(2,1,2);
spectrogram(mag3,120,60,512,'yaxis');


x4 = M4(:,1);
y4 = M4(:,2);
z4 = M4(:,3);
t4 = M4(:,5);
figure;
mag4 = sqrt(x4.^2 + y4.^2 + z4.^2);
subplot(2,1,1);
plot(t4,mag4);
xlabel('Time (ms)');
ylabel('Acceleration (0.01m/s^2)');
title('Running');
subplot(2,1,2);
spectrogram(mag4,120,60,512,'yaxis');

x5 = M5(:,1);
y5 = M5(:,2);
z5 = M5(:,3);
t5 = M5(:,5);
figure;
mag5 = sqrt(x5.^2 + y5.^2 + z5.^2);
plot(t5,x5,t5,y5,t5,z5);
title('Bus travelling');
legend('x','y','z');
grid on;
subplot(2,1,1);
plot(t5,mag5);
xlabel('Time (ms)');
ylabel('Acceleration (0.01m/s^2)');
title('Bus Travelling');
subplot(2,1,2);
spectrogram(mag5,120,60,512,'yaxis');


%Plotting 250 point FFT, splitting data in 250 points a window
% and with 50% overlap. Computing average of that, and then finding
% the FFT of that

[buf1 temp1] = buffer(mag1,512,256,'nodelay');
[buf2 temp2] = buffer(mag2,512,256,'nodelay');
[buf3 temp3] = buffer(mag3,512,256,'nodelay');
[buf4 temp4] = buffer(mag4,512,256,'nodelay');
[buf5 temp5] = buffer(mag5,512,256,'nodelay');

wind1 = sum(buf1,2)/size(buf1,2);
wind2 = sum(buf2,2)/size(buf2,2);
wind3 = sum(buf3,2)/size(buf3,2);
wind4 = sum(buf4,2)/size(buf4,2);
wind5 = sum(buf5,2)/size(buf5,2);

NFFT=512; nVals=0:NFFT-1;

X1=fftshift(fft(wind1,NFFT));
X2=fftshift(fft(wind2,NFFT));
X3=fftshift(fft(wind3,NFFT));
X4=fftshift(fft(wind4,NFFT));
X5=fftshift(fft(wind5,NFFT));

figure;
plot(nVals,log10(abs(X1)),nVals,log10(abs(X2)),nVals,log10(abs(X3)),nVals,log10(abs(X4)),nVals,log10(abs(X5)));
legend('Decending  Down','Going up in Lift','Jogging','Running','Bus');
xlabel('Shifted FFT Indices');
ylabel('log abs FFT coefficients');
title('fft index vs fft coeff');


% NFFT=4096; nVals=0:NFFT-1;
% X11=fftshift(fft(mag1,NFFT));
% X22=fftshift(fft(mag2,NFFT));
% figure;
% plot(nVals,log10(abs(X11)),nVals,log10(abs(X22)));
% legend('stair','lift');
% title('fft index vs fft coeff');

eng1 = buf1.^2;
fin_eng1 = sum(eng1,1);
eng2 = buf2.^2;
fin_eng2 = sum(eng2,1);
eng3 = buf3.^2;
fin_eng3= sum(eng3,1);
eng4 = buf4.^2;
fin_eng4 = sum(eng4,1);
eng5 = buf5.^2;
fin_eng5 = sum(eng5,1);
fin_eng1=fin_eng1';
fin_eng2=fin_eng2';
fin_eng3=fin_eng3';
fin_eng4=fin_eng4';
fin_eng5=fin_eng5';



figure;
tempx=[fin_eng1;fin_eng2;fin_eng3;fin_eng4;fin_eng5];
tempg=[ones(size(fin_eng1));2*ones(size(fin_eng2));3*ones(size(fin_eng3));4*ones(size(fin_eng4));5*ones(size(fin_eng5))];
boxplot(tempx,tempg,'labels',{'Stairs','Elevator','Jogging','Running','Sitting in bus'});
title('Distribution of energy over all window');
xlabel('Mode of Transport');
ylabel('Energy of window');

figure;
tempm1=mean(buf1,1);
mean1=tempm1';
tempm2=mean(buf2,1);
mean2=tempm2';
tempm3=mean(buf3,1);
mean3=tempm3';
tempm4=mean(buf4,1);
mean4=tempm4';
tempm5=mean(buf5,1);
mean5=tempm5';
tempxm=[mean1;mean2;mean3;mean4;mean5];
tempgm=[ones(size(mean1));2*ones(size(mean2));3*ones(size(mean3));4*ones(size(mean4));5*ones(size(mean5))];
boxplot(tempxm,tempgm,'labels',{'Stairs','Elevator','Jogging','Running','Sitting in bus'});
title('Dsitribution of mean over all window');
xlabel('Mode of Transport');
ylabel('Mean of window');

figure;
tempv1=var(buf1,1);
var1=tempv1';
tempv2=var(buf2,1);
var2=tempv2';
tempv3=var(buf3,1);
var3=tempv3';
tempv4=var(buf4,1);
var4=tempv4';
tempv5=var(buf5,1);
var5=tempv5';
tempxv=[var1;var2;var3;var4;var5];
tempgv=[ones(size(var1));2*ones(size(var2));3*ones(size(var3));4*ones(size(var4));5*ones(size(var5))];
boxplot(tempxv,tempgv,'labels',{'Stairs','Elevator','Jogging','Running','Sitting in bus'});
title('Distribution of variance over all window');
xlabel('Mode of Transport');
ylabel('Variance of window');

%Dominant Freq
Fs = 50;
wind1 = wind1 - mean(wind1);
dom1 = fft(wind1,NFFT);
dom1 = abs(dom1.^2);
dom1 = dom1(1:1+NFFT/2); % half-spectrum
[v1,k1] = max(dom1); % find maximum
f_scale1 = (0:NFFT/2)* Fs/NFFT; % frequency scale
fest1 = f_scale1(k1); % dominant frequency estimate

wind2 = wind2 - mean(wind2);
dom2 = fft(wind2,NFFT);
dom2 = abs(dom2.^2);
dom2 = dom2(1:1+NFFT/2); % half-spectrum
[v2,k2] = max(dom2); % find maximum
f_scale2 = (0:NFFT/2)* Fs/NFFT; % frequency scale
fest2 = f_scale2(k2); % dominant frequency estimate

wind3 = wind3 - mean(wind3);
dom3 = fft(wind3,NFFT);
dom3 = abs(dom3.^2);
dom3 = dom3(1:1+NFFT/2); % half-spectrum
[v3,k3] = max(dom3); % find maximum
f_scale3 = (0:NFFT/2)* Fs/NFFT; % frequency scale
fest3 = f_scale3(k3); % dominant frequency estimate

wind4 = wind4 - mean(wind4);
dom4 = fft(wind4,NFFT);
dom4 = abs(dom4.^2);
dom4 = dom4(1:1+NFFT/2); % half-spectrum
[v4,k4] = max(dom4); % find maximum
f_scale4 = (0:NFFT/2)* Fs/NFFT; % frequency scale
fest4 = f_scale4(k4); % dominant frequency estimate

wind5 = wind5 - mean(wind5);
dom5 = fft(wind5,NFFT);
dom5 = abs(dom5.^2);
dom5 = dom5(1:1+NFFT/2); % half-spectrum
[v5,k5] = max(dom5); % find maximum
f_scale5 = (0:NFFT/2)* Fs/NFFT; % frequency scale
fest5 = f_scale5(k5); % dominant frequency estimate
%Printing dominant frequency
fest1
fest2
fest3
fest4
fest5
