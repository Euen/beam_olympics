-module(bo_players).

-behaviour(sumo_doc).

-type name() :: binary().

-opaque player() ::
  #{ name := name()
   , node := node()
   , task := module() | undefined
   , done := [module()]
   , created_at => calendar:datetime()
   }.

-export_type(
  [ name/0
  , player/0
  ]).

%% sumo_doc behaviour callbacks
-export(
  [ sumo_schema/0
  , sumo_sleep/1
  , sumo_wakeup/1
  ]).

-export(
  [ new/2
  , node/1
  , task/1
  , done/1
  , finish/1
  , task/2
  ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sumo_doc behaviour callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-spec sumo_schema() -> sumo:schema().
sumo_schema() ->
  sumo:new_schema(
    ?MODULE,
    [ sumo:new_field(name, string, [id, unique])
    , sumo:new_field(node, custom, [not_null])
    , sumo:new_field(task, custom, [])
    , sumo:new_field(done, custom, [not_null])
    , sumo:new_field(created_at, datetime, [not_null])
    ]).

-spec sumo_sleep(player()) -> sumo:doc().
sumo_sleep(Player) -> Player.

-spec sumo_wakeup(sumo:doc()) -> player().
sumo_wakeup(Player) -> Player.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% public API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-spec new(name(), node()) -> player().
new(Name, Node) ->
  #{ name => Name
   , node => Node
   , task => bo_tasks:first()
   , done => []
   , created_at => calendar:universal_time()
   }.

-spec node(player()) -> node().
node(#{node := Node}) -> Node.

-spec task(player()) -> module().
task(#{task := Task}) -> Task.

-spec done(player()) -> [module()].
done(#{done := Done}) -> Done.

-spec finish(player()) -> player().
finish(Player) ->
  #{task := Task, done := Done} = Player,
  Player#{task := undefined, done := [Task|Done]}.

-spec task(player(), module()) -> player().
task(Player, NextTask) ->
  #{task := Task, done := Done} = Player,
  Player#{task := NextTask, done := [Task|Done]}.
