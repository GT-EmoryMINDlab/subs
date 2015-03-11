function [newtc]=zeromean(oldtc);

oldtc=detrend(oldtc);
newtc=(oldtc-mean(oldtc))/std(oldtc);

    