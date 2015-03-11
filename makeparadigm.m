%takes number of rest, act, rest points and returns a reference time course

function [reftimecourse]=makeparadigm(rest1,act,rest2);

resttc1=zeros(rest1,1);
resttc2=zeros(rest2,1);
acttc=zeros(act,1);
acttc=acttc+1.0;
reftimecourse=squeeze([resttc1;acttc;resttc2]);

