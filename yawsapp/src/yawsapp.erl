%%
%% The core yawsapp.erl file provides the yawsapp:start/2 and yawsapp:stop/1 functions as per
%% the application behavior. You'll also note that it pulls the two environmental variables set
%% in the application configuration file. Those values are passed to the yawsapp_sup:start_link/1
%% function.
%%
-module(yawsapp).
-behaviour(application).

-export([start/2, stop/1]).

-include("include/yawsapp.hrl").

start(_Type, _Args) ->
    mnesia:start(),
    application:start(inets),
    Args = lists:map(
        fun (Var) -> {ok, Value} = application:get_env(?MODULE, Var), Value end,
        [port, working_dir]
    ),
    yawsapp_sup:start_link(Args).

stop(_State) -> ok.