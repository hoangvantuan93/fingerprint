function [ id_max num_max percent_max ] = recognize(pathMap, endListReal)
%RECOGNIZE Summary of this function goes here
%   Detailed explanation goes here

input = [endListReal; pathMap];
[id_max num_max percent_max] = onevsall(input,1);

end

