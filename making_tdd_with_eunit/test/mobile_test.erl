-module(mobile_test).

-include_lib("eunit/include/eunit.hrl").

describe_client_test_() ->
  {"Mobile",
    {"when is a dummy",
      [
        {"should have a fixed number",
          fun should_have_a_fixed_number/0},
        {"should have a fixed area code",
          fun should_have_a_fixed_area_code/0},
        {"should have a fixed company",
          fun should_have_a_fixed_company/0},
        {"should have a fixed owner",
          fun should_have_a_fixed_owner/0}
      ]}}.
      
should_have_a_fixed_number() ->
  ?assertMatch({number, "1212-1212"}, mobile:number()).

should_have_a_fixed_area_code() ->
  ?assertMatch({area_code, "11"}, mobile:area_code()).

should_have_a_fixed_company() ->
  ?assertMatch({company, "DEAD"}, mobile:company()).

should_have_a_fixed_owner() ->
  ?assertMatch({owner, "Little Jose"}, mobile:owner()).