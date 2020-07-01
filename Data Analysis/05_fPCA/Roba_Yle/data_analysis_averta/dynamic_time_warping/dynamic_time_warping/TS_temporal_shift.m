function [ TS_Shifted ] = TS_temporal_shift( TS, Tshift )
%given a timeseries TS, TS_Shifted is a shifting of TS (positive/negative)

TS.time = TS.time + ceil(Tshift);

TS_Shifted = TS;

end

