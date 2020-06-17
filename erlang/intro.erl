-module(intro).

-export([times/2, divide/2, dogs_per_legs/1, length/1,
         dillo1/0, dillo2/0,
         run_over_dillo/1,
         parrot1/0,
         format_server_0/0, format_server_1_loop/0, format_server_1/0]).

times(X, N) -> X * N.

divide(N, M) ->
    if 
        M == 0 -> {error, divide_by_zero};
        true -> {ok, N / M}
    end.

-spec dogs_per_legs(pos_integer()) -> pos_integer().
dogs_per_legs(Legs) ->
    case divide(Legs, 4) of 
        {ok, Dogs} -> Dogs;
        {error, divide_by_zero} -> io:format("Impossible!")
    end.

length([]) -> 0;
length([_Head|Tail]) -> 1 + intro:length(Tail).

-record(dillo, {alive :: boolean(), weight :: pos_integer()}).


dillo1() -> #dillo{alive = true, weight = 10}.
dillo2() -> #dillo{alive = false, weight = 12}.

-spec run_over_dillo(#dillo{}) -> #dillo{}.
run_over_dillo(#dillo{weight = Weight}) ->
    #dillo{alive = false, weight = Weight}.

-record(parrot, {sentence :: string(), weight :: pos_integer()}).

parrot1() -> #parrot{sentence = "Hallo", weight = 2}.

foo() ->
    P1 = parrot1(),
    N = #parrot.sentence, %% Position
    P1#parrot.sentence.

-type animal() :: #dillo{} | #parrot{}.

map(F, []) -> [];
map(F, [Head|Tail]) -> [F(Head) | map(F, Tail)].

format_server_0() ->
    spawn(fun () ->
            receive
                Message -> io:format(Message)
            after 10000 ->
                io:format("timeout~n")
            end 
          end).

format_server_1_loop() ->
    receive
        Message -> io:format(Message)
    after 10000 ->
        io:format("timeout~n")
    end,
    format_server_1_loop().

format_server_1() ->
    %% spawn(fun format_server_1_loop/0).
    spawn(intro, format_server_1_loop, []).
    
