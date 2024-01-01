signal = elec1;
plot_fmin = 0;
plot_fmax = 1000;

close all

[Pxx, Fspec] = periodogram(signal);

f = Fspec*samplingrate/(2*pi);

figure(1)
plot(f, log10(Pxx))
axis([plot_fmin plot_fmax -5 8])
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
xlabel('frequency (Hz)')
ylabel('Log(power)')