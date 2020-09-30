alias_transform
=====

A demo library that introduces module aliasing attributes into an Erlang code base.

Import it in your project by declaring a build-time dependency in `rebar.config`:

```erlang
{deps, [
    {alias_transform,
        {git, "https://github.com/ferd/alias_transform.git", {branch, "main"}}}
}.
```

You can then configure the parse transform to run against all your modules:

```erlang
{erl_opts, [
    {parse_transform, alias_transform}
]}.
```

There is no need to declare the library as a run-time dependency since it
operates entirely at compile-time.  Inside any Erlang module, you can declare
and use aliases such as:

```erlang
-module(whatever).

%%      Original Module Name                         Short Alias
-alias({thrift_foo_namespace_bar_module_baz_service, service}).

f() ->
    %% The call is automatically substituted here:
    fun service:call/0,
    %% and also in:
    service:call().
```

## Limitations

Currently, this does not handle cases such as `apply(M, F, Args)`,
`spawn(M, F, Args)`, or module names passed as process or table names,
and so on.

It wouldn't necessarily be super hard to cover the direct literal cases,
but it would fail when indirect assingment using variables takes place.

Similarly, remote types of the form `M:T(...)` are currently not expanded.

This is more of a proof of concept than a serious attempt.

## Development

There's a minimal test suite in `test/`. You can execute it by calling `rebar3 ct`.

