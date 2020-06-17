-module(inc_server).

-behavior(gen_server).

-export([init/1, start/1,
         inc/2, get/1,
         handle_cast/2, handle_call/3]).

-record(get, {sender_pid :: pid() }). % sender_pid bei gen_server überflüssig
-record(inc, {increment :: number()}).

%% N: Anfangsstand des Zählers
init(N) ->
    {ok, N}. % Anfangszustand vom gen_server

inc(Pid, Increment) ->
    gen_server:cast(Pid, #inc{increment = Increment}).

get(Pid) ->
    gen_server:call(Pid, #get{sender_pid = self()}).

start(N) ->
    gen_server:start({global, global_inc}, ?MODULE, N, []).
                                                  % ^ wird an init übergeben

handle_cast(#inc{increment = Increment}, N) ->
    {noreply, N + Increment}.

handle_call(#get{}, _From, N) ->
    {reply, N, N}.

