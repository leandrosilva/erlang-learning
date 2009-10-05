%%
%% The yawsapp_handler module is the module used by yaws to process incoming requests. It provides
%% the yawsapp_handler:out/1 function that Yaws calls with the record that defines the incoming
%% request. From that method we do a very simple dispatch through the
%% yawsapp_handler:handle_request/3 function based on the request method, request path and request
%% argument.
%%
%% In this example we provide functions to handle /account and /profile locations as well as a
%% function to handle all other requests (a catch-all). This simple application can easily be
%% extended to act as an interface to your erlang applications. You may have to adjust some of the
%% yaws include locations to suite your erlang installation, but its generic enough to work for most
%% people as-is.
%%
-module(yawsapp_handler).

-include("/opt/local/lib/yaws/include/yaws.hrl").
-include("/opt/local/lib/yaws/include/yaws_api.hrl").
-include("include/yawsapp.hrl").

-export([out/1, handle_request/3]).

out(Arg) ->
  	Req = Arg#arg.req,
  	ReqPath = get_path(Arg),
  	handle_request(Req#http_request.method, ReqPath, Arg).

get_path(Arg) ->
    Req = Arg#arg.req,
    {abs_path, Path} = Req#http_request.path,
    Path.

handle_request('GET', "/account", _Arg) -> % "/account" only
    make_response(200, "<p>Please login or logout.</p>");

handle_request('GET', [47,112,114,111,102,105,108,101 | _], _Arg) -> % "/profile" ...
    make_response(200, "<p>This is a slick profile.</p>");

%%
%% My custom function to test delegation.
%%
%% The yawsapp_handler_custom module is a process started at yawsapp_server:init/1 function.
%%
handle_request('GET', "/custom", _Arg) -> % "/custom" only
		yawsapp_handler_custom ! {request, self(), 'GET', "/custom", _Arg},
		receive
			{response, Status, Message} -> make_response(Status, Message)
		end;

handle_request(_, _, _Arg) -> % catchall
    make_response(200, "<p>What exactly are you looking for?</p>").

make_response(Status, Message) ->
    make_response(Status, "text/html", Message).

make_response(Status, Type, Message) ->
    make_all_response(Status, make_header(Type), Message).

make_header(Type) ->
    [{header, ["Content-Type: ", Type]}].

make_all_response(Status, Headers, Message) ->
    [{status, Status}, {allheaders, Headers}, {html, Message}].