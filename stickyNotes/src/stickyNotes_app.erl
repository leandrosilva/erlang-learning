%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the stickyNotes application.

-module(stickyNotes_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for stickyNotes.
start(_Type, _StartArgs) ->
    stickyNotes_deps:ensure(),
    stickyNotes_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for stickyNotes.
stop(_State) ->
    ok.
