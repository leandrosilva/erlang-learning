%%
%% The yawsapp_server module does the bulk of the work involved in setting up and initializing the
%% embedded yaws application and its configuration. This module is called first through the
%% yawsapp_server:start_link/1 function that implements the gen_server behavior of the module.
%% 
%% During the init phase the module attempts to start the yaws application and on success it builds
%% two configuration variables that are then passed to yaws_api:setconf/2. The configuration
%% variables set the standard options, such trace level, log directory, port, docroot, etc. It also
%% sets the appmod configuration option dictating that the "/" request is handled by the
%% yawsapp_handler module.
%%
-module(yawsapp_server).
-behaviour(gen_server).

-include("/opt/local/lib/yaws/include/yaws.hrl").
-include("include/yawsapp.hrl").

-export([
    start_link/1, init/1,
    handle_call/3, handle_cast/2, handle_info/2,
    terminate/2, code_change/3
]).

start_link(Args) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Args, []).

init(Args) ->
    process_flag(trap_exit, true),

		%% here we might spawn a lot of custom handlers to deal with our http requests
		register(yawsapp_handler_custom, spawn_link(yawsapp_handler_custom, loop, [null])),

    case application:start(yaws) of
        ok -> set_conf(Args);
        Error -> {stop, Error}
    end.

set_conf([Port, WorkingDir]) ->
    GC = #gconf{
        trace = false,
        logdir = WorkingDir ++ "/logs",
        yaws = "YawsApp 1.0" %%,
        %% tmpdir = WorkingDir ++ "/.yaws"
    },
    SC = #sconf{
        port = Port,
        servername = "localhost",
        listen = {0, 0, 0, 0},
        docroot = "../www",
        appmods = [{"/", yawsapp_handler}]
    },
    case catch yaws_api:setconf(GC, [[SC]]) of
        ok -> {ok, started};
        Error -> {stop, Error}
    end.

handle_call(Request, _From, State) -> {stop, {unknown_call, Request}, State}.

handle_cast(_Message, State) -> {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) ->
    application:stop(yaws),
    ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.