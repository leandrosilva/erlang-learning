%%
%% Exercise 3-1: Evaluating Expressions
%%

-module(eval_expression).
-export([sum/1]).

sum(N) when N > 0 ->
	sum(N, 0).

sum(0, Acc) ->
		Acc;
sum(N, Acc) ->
	sum(N - 1, Acc + N).
