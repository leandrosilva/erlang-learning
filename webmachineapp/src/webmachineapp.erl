%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.

-module(webmachineapp).
-author('author <author@example.com>').
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
	ok ->
	    ok;
	{error, {already_started, App}} ->
	    ok
    end.
	
%% @spec start() -> ok
%% @doc Start the webmachineapp server.
start() ->
    webmachineapp_deps:ensure(),
    ensure_started(crypto),
    ensure_started(webmachine),
    application:start(webmachineapp).

%% @spec stop() -> ok
%% @doc Stop the webmachineapp server.
stop() ->
    Res = application:stop(webmachineapp),
    application:stop(webmachine),
    application:stop(crypto),
    Res.
