function data_lf=lpfilterimage(data,tr,cutpt,dim);

[b,a]=butter(5,cutpt/((1/tr)/2));
hd=dfilt.df2t(b,a);
data_lf=zeros(dim(1,1),dim(1,2),dim(1,3),dim(1,4));

for x=1:dim(1,1)
    for y=1:dim(1,2)
        for z=1:dim(1,3)
            if(data(x,y,z,1)~=0)
                tc=data(x,y,z,:);
                %tc=detrend(tc);
                tc=(tc-mean(tc))/std(tc);
                newtc=filter(hd,tc);
                data_lf(x,y,z,:)=squeeze(newtc);
            else
                data_lf(x,y,z,:)=0;
            end
        end
    end
end
%tcnew=real(ifft(tc2)); 
           
disp('Filtering complete!');

