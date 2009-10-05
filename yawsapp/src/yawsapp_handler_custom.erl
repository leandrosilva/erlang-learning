%%
%% Test module used by yawsapp_handler:handle_request/3.
%%
%% That's started at yawsapp_server:init/1.
%%
-module(yawsapp_handler_custom).

-export ([loop/1]).

loop(_Data) ->
	receive
		{request, From, _Method, _URI, _Arg} -> From ! handle_request(_Method, _URI, _Arg)
	end,
	loop(_Data).

handle_request('GET', "/custom", _Arg) ->
	{response, 200, "<p>Response from custom handler</p>"}.