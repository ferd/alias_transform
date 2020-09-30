-module(alias_transform).
-export([parse_transform/2]).

parse_transform(ASTs, _Options) ->
    try
        Aliases = lists:foldl(
            fun(AST, Map) ->
                erl_syntax_lib:fold(fun(T, M) -> find_aliases(erl_syntax:revert(T), M) end, Map, AST)
            end,
            #{},
            ASTs
        ),
        [erl_syntax_lib:map(fun(T) ->
             transform(erl_syntax:revert(T), Aliases)
         end, AST) || AST <- ASTs]
    catch
        _:_ ->
            ASTs
    end.

find_aliases({attribute, _Line, alias, {From, To}}, Map) ->
    Map#{To => From};
find_aliases(_, Map) ->
    Map.

transform({call, Line, {remote, _, {atom, _, Mod}, F}, Args}=Call, Aliases) ->
    case Aliases of
        #{Mod := RealMod} ->
            {call, Line, {remote, Line, {atom, Line, RealMod}, F}, Args};
        _ ->
            Call
    end;
transform({'fun', Line, {function, {atom, Loc, Mod}, Name, Arity}}=Fun, Aliases) ->
    case Aliases of
        #{Mod := RealMod} -> {'fun', Line, {function, {atom, Loc, RealMod}, Name, Arity}};
        _ -> Fun
    end;
transform(Term, _) ->
    Term.
