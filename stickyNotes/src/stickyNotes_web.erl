%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Web server for stickyNotes.

-module(stickyNotes_web).
-author('author <author@example.com>').

-export([start/1, stop/0, loop/2]).

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot)
           end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    mochiweb_http:stop(?MODULE).

loop(Req, DocRoot) ->
    "/" ++ Path = Req:get(path),
    case Req:get(method) of
        Method when Method =:= 'GET'; Method =:= 'HEAD' ->
            case Path of
                _ ->
                    Req:serve_file(Path, DocRoot)
            end;
        'POST' ->
            case Path of
							"notes" ->
								Data = Req:parse_post(),

								Json = proplists:get_value("json", Data),
								Struct = mochijson2:decode(Json),

								%%io:format("~nStruct : ~p~n", [Struct]),

								A = struct:get_value(<<"action">>, Struct),
								Action = list_to_existing_atom(binary_to_list(A)),
								

								Result = notes:Action(Struct),

								%%io:format("~nResult : ~p~n", [Result]),

								DataOut = mochijson2:encode(Result),

								Req:ok({"application/json", [], [DataOut]});

                _ ->
                    Req:not_found()
            end;
        _ ->
            Req:respond({501, [], []})
    end.

%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.
