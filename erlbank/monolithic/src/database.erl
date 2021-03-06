%% This module represents the database layer

-module(database).
-include("data.hrl").
-export([init_database/0,
         put_account/1, get_account/1, get_all_accounts/0,
         put_person/1, get_person/1, get_all_persons/0, 
         put_transaction/1, get_transaction/1, get_all_transactions/0, get_all_transactions/1, 
         unique_account_number/0,unique_tx_id/0, unique_person_id/0]).

%% id-table for atomic id increment
-record(table_id, {table_name :: mnesia:table(), last_id :: non_neg_integer()}).

%% destroy tables in case they already existed
destroy_tables() ->
    mnesia:del_table_copy(person, node()),
    mnesia:del_table_copy(transaction, node()),
    mnesia:del_table_copy(account, node()).

create_tables() ->
    mnesia:create_table(person, [{attributes, record_info(fields, person)}]),
    mnesia:create_table(transaction, [{attributes, record_info(fields, transaction)}]),
    mnesia:create_table(account, [{attributes, record_info(fields, account)}]),
    mnesia:create_table(table_id, [{record_name, table_id}, {attributes, record_info(fields, table_id)}]).


init_database() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    destroy_tables(),
    create_tables(),
    ok.


write(Obj) ->
    Fun = fun() -> mnesia:write(Obj) end,
    {atomic, ok} = mnesia:transaction(Fun),
    ok.


-spec read_one(mnesia:table(), unique_id()) -> {ok, tuple()} | {error, not_found | more_than_one}.
read_one(Table, Id) ->
    Fun = fun() -> mnesia:read(Table, Id) end,
    {atomic, Res} = mnesia:transaction(Fun),
    case Res of
        [A] -> {ok, A};
        []  -> {error, not_found};
        [_ | _] -> {error, more_than_one}
    end.

-spec read_all(mnesia:table()) -> list(tuple()).
read_all(Table) ->
    Fun = fun() -> mnesia:select(Table,[{'_',[],['$_']}]) end,
    {atomic, Res} = mnesia:transaction(Fun),
    Res.

-spec put_account(#account{}) -> ok.
put_account(Account) ->
    write(Account).

-spec get_account(account_number()) -> {ok, #account{}} | {error, any()}.
get_account(AccountNumber) ->
    read_one(account, AccountNumber).

-spec get_all_accounts() -> list(#account{}).
get_all_accounts() ->
    read_all(account).


-spec put_person(#person{}) -> ok.
put_person(Person) ->
    write(Person).

-spec get_person(unique_id()) -> {ok, #person{} | {error, any()}}.
get_person(PersonId) ->
    read_one(person, PersonId).

-spec get_all_persons() -> list(#person{}).
get_all_persons() ->
    read_all(person).


-spec put_transaction(#transaction{}) -> ok.
put_transaction(Transaction) ->
    write(Transaction).

-spec get_transaction(unique_id()) -> {ok, #transaction{}} | {error, any()}.
get_transaction(TransactionId) ->
    read_one(transaction, TransactionId).

-spec get_all_transactions() -> list(#transaction{}).
get_all_transactions() ->
    read_all(transaction).

-spec get_all_transactions(account_number()) -> list(#transaction{}).
get_all_transactions(AccountNr) ->
    Fun = fun() ->
            mnesia:select(transaction,
                           [{'$1',
                            [{'orelse',
                                {'==', {element, #transaction.from_acc_nr, '$1'}, AccountNr},
                                {'==', {element, #transaction.to_acc_nr, '$1'}, AccountNr}}],
                            ['$_']}]) 
          end,
    {atomic, Res} = mnesia:transaction(Fun),
    Res.

-spec unique_account_number() -> unique_id().
unique_account_number() -> mnesia:dirty_update_counter(table_id, account, 1).

-spec unique_person_id() -> unique_id().
unique_person_id() -> mnesia:dirty_update_counter(table_id, person, 1).

-spec unique_tx_id() -> unique_id().
unique_tx_id() -> mnesia:dirty_update_counter(table_id, transaction, 1).

