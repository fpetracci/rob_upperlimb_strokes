function [ TS_Stretch ] = TS_stretch( TS, Nstretch )
%Resample a TS by a Nstretch factor

ts_st = TS;
time_zero = ts_st.time(1);
ts_st.time = ts_st.time - time_zero;

%a = ts_st.time * Nstretch;
% size(ts_st.data(:))
ts_st.time =  ts_st.time * Nstretch;
%a =   [0 : (ts_st.time(end)*Nstretch)]';

%size(ts_st.data(:))
%size(a)
a =  [0 : ts_st.time(end) * Nstretch]';
ts_st = resample(ts_st,a);


ts_st.time = ts_st.time + time_zero;

TS_Stretch = ts_st;
end

