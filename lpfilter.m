function data_lf=lpfilter(data,tr,cutpt);

[b,a]=butter(5,cutpt/((1/tr)/2));
hd=dfilt.df2t(b,a);
data_lf=filter(hd,data);
%tcnew=real(ifft(tc2)); 
           

