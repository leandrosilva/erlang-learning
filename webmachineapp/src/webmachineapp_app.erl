%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the webmachineapp application.

-module(webmachineapp_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for webmachineapp.
start(_Type, _StartArgs) ->
    webmachineapp_deps:ensure(),
    webmachineapp_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for webmachineapp.
stop(_State) ->
    ok.
