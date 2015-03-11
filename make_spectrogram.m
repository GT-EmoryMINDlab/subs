function []=make_spectrogram(tc);

[testspec, f, t1]=specgram(tc,256,10);
figure;
imagesc(t,f,20*log10(abs(testspec))) ,axis xy,colormap(jet);
    
