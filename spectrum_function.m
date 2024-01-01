function [f, Pxx] = spectrum_function(signal, samplingrate, plot_fmin, plot_fmax)

close all

[Pxx, Fspec] = periodogram(signal);

f = Fspec*samplingrate/(2*pi);

figure(1)
plot(f, log10(Pxx))
axis([plot_fmin plot_fmax -5 12])
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
xlabel('frequency (Hz)')
ylabel('Log(power)')