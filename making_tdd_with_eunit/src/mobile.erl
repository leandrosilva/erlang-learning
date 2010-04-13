-module(mobile).

-export([number/0, area_code/0, company/0, owner/0]).

number() ->
  {number, "1212-1212"}.

area_code() ->
  {area_code, "11"}.

company() ->
  {company, "DEAD"}.

owner() ->
  {owner, "Little Jose"}.