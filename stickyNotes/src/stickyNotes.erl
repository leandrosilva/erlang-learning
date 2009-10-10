%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.

-module(stickyNotes).
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
%% @doc Start the stickyNotes server.
start() ->
    stickyNotes_deps:ensure(),
    ensure_started(crypto),
    ensure_started(mnesia),
    application:start(stickyNotes).

%% @spec stop() -> ok
%% @doc Stop the stickyNotes server.
stop() ->
    Res = application:stop(stickyNotes),
    application:stop(mnesia),
    application:stop(crypto),
    Res.
