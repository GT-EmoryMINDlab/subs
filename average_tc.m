%averages time courses from a seed region.  currently only 1 slice

function avgtc=average_tc(data,pix,slice);

tsz=size(data,4);
avgtc=zeros(1,tsz);
temp=zeros(1,tsz);
sz=size(pix);

    for i=1:sz(1,1)
        %may need to swap pix based on image orientation
        temp=data(pix(i,2),pix(i,1), slice,:);
        avgtc(1,:)=avgtc(1,:)+temp(1,:);
    end


avgtc=avgtc/sz(1,1);

    

           

