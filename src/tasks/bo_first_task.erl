-module(bo_first_task).

-behaviour(bo_task).

-export([description/0, expected_arity/0, timeout/0, tests/0]).

-spec description() -> binary().
description() -> <<"Echo: Return whatever you receive">>.

-spec expected_arity() -> 1.
expected_arity() -> 1.

-spec timeout() -> 1000.
timeout() -> 1000.

-spec tests() -> [bo_task:test()].
tests() -> [build_test(Input) || Input <- [a, 1, 2.14, #{}]].

build_test(Something) ->
  fun(Fun) ->
    case Fun(Something) of
      Something -> ok;
      SomethingElse -> {error, #{ input => Something
                                , output => SomethingElse
                                , expected => Something
                                }}
    end
  end.
