-module(ossp_uuid).

-export([make/2, make/4]).

-on_load(init/0).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

init() ->
    case code:which(?MODULE) of
        Filename when is_list(Filename) ->
            erlang:load_nif(filename:join([filename:dirname(Filename),"../priv/ossp_uuid_drv"]), []);
        Err ->
            Err
    end.

make(_Mode, _Format) ->
    erlang:nif_error(not_loaded).

make(_Mode, _Format, _NS, _Name) ->
    erlang:nif_error(not_loaded).

%% ===================================================================
%% EUnit tests
%% ===================================================================
-ifdef(TEST).

make_v1_test() ->
    B1 = make(v1, binary),
    ?assert(is_binary(B1)),
    ?assertEqual(16, size(B1)),
    S1 = make(v1, text),
    ?assertEqual(36, size(S1)).

make_v3_test() ->
    B1 = make(v3, binary, "ns:URL", "http://example.org"),
    ?assert(is_binary(B1)),
    ?assertEqual(16, size(B1)),
    ?assertEqual(B1,  make(v3, binary, "ns:URL", "http://example.org")),
    S1 = make(v3, text, "ns:URL", "http://example.org"),
    ?assertEqual(36, size(S1)),
    ?assertEqual(S1,  make(v3, text, "ns:URL", "http://example.org")).

make_v4_test() ->
    B1 = make(v4, binary),
    ?assert(is_binary(B1)),
    ?assertEqual(16, size(B1)),
    S1 = make(v4, text),
    ?assertEqual(36, size(S1)).

make_v5_test() ->
    B1 = make(v5, binary, "ns:URL", "http://example.org"),
    ?assert(is_binary(B1)),
    ?assertEqual(16, size(B1)),
    ?assertEqual(B1,  make(v5, binary, "ns:URL", "http://example.org")),
    S1 = make(v5, text, "ns:URL", "http://example.org"),
    ?assertEqual(36, size(S1)),
    ?assertEqual(S1,  make(v5, text, "ns:URL", "http://example.org")).
    

-endif.
