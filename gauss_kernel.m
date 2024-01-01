% apply Gaussian kernel on data.

function c = gauss_kernel(y, timebins, SD)

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load image
end

binduration = diff(timebins(1:2));

kernelSD=round(SD/binduration);

gausskernel=fspecial('gaussian', [1 10*kernelSD], kernelSD);

c = conv(y, gausskernel, 'same');

close all
figure(1)
plot(timebins, c)
h = get(gcf, 'CurrentAxes');
set(h, 'FontSize', 16, 'LineWidth', 0.5);
xlabel('frequency (Hz)')
ylabel('Log(power)')