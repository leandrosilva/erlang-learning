-module(notes).
-compile(export_all).

-include("records.hrl").

read_all(_S) -> 
	Notes = stickydb:read_all(note),
	lists:map(fun(F) -> {struct, [{<<"id">>, F#note.id}, {<<"doc">>, F#note.doc}]} end, Notes).

create(S) ->
	Doc = struct:get_value(<<"doc">>, S),
	Id = stickydb:new_id(note),
	{atomic, ok} = stickydb:write({note, Id, Doc}),
	S1 = struct:set_value(<<"id">>, Id, S),
	[S1].

read(S) ->
	Id = struct:get_value(<<"id">>, S),

	case stickydb:read({note, Id}) of
		[Doc] ->
			{struct, [{<<"doc">>, Doc}]};
		[] ->
			{struct, [{<<"message">>, <<"note not found">>}]}
	end.

update(S) ->
	Id = struct:get_value(<<"id">>, S),
	Doc = struct:get_value(<<"doc">>, S),
	{atomic, ok} = stickydb:write({note, Id, Doc}),
	{struct, [{<<"message">>, ok}]}.

delete(S) ->
	Id = struct:get_value(<<"id">>, S),
	{atomic, ok} = stickydb:delete({note, Id}),
	{struct, [{<<"message">>, ok}]}.
