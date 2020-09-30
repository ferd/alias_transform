-module(alias_transform_SUITE).
-compile({parse_transform, alias_transform}).
-alias({?MODULE, chk}).
-export([all/0,
         remote_call/1, remote_fun/1]).

%% Test exports
-export([a/0, a/1, b/0]).

all() -> [remote_call, remote_fun].

%% @doc check `Mod:Fun(Args)' calls. If the parse transform does not work
%% this test fails with `undef' exceptions.
remote_call(_Config) ->
    chk:a(),
    chk:a(2),
    chk:b(),
    ok.

remote_fun(_Config) ->
    Calls = [{fun chk:a/0, []},
             {fun chk:a/1, [hello]},
             {fun chk:b/0, []}],
    [apply(F, Args) || {F, Args} <- Calls],
    ok.

%%%%%%%%%%%%%%%
%%% HELPERS %%%
%%%%%%%%%%%%%%%
a() -> ok.
a(_) -> ok.
b() -> ok.
