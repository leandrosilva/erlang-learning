%%
%% To see informations about this module in Erlang shell do it:
%%
%% 1> demo:module_info().
%%
%% or:
%%
%% 1> m(demo).
%%
-module(demo). 
-export([double/1]). 

double(Value) -> 
  times(Value, 2). 
times(X,Y) -> 
  X*Y.
