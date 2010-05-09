-module(system_info).

-export([node_load/0, cluster_load/0]).
-export([node_processes/0, cluster_processes/0]).
-export([node_memory/0, cluster_memory/0]).

-define(TIMEOUT, 3000).

%%
%% Public API
%%

node_load() ->
  start_system_services(),
  get_node_load().

cluster_load() ->
  start_system_services(),
  get_cluster_load().

node_processes() ->
  start_system_services(),
  get_node_processes().

cluster_processes() ->
  start_system_services(),
  get_cluster_processes().

node_memory() ->
  start_system_services(),
  get_node_memory().

cluster_memory() ->
  start_system_services(),
  get_cluster_memory().  

%%
%% Private API
%%

start_system_services() ->
  start_cpu_sup(),
  start_mem_sup(),
  ok.
  
start_cpu_sup() ->
  case whereis(cpu_sup) of
    undefined -> cpu_sup:start();
    _ -> already_started
  end,
  
  started.

start_mem_sup() ->
  case whereis(memsup) of
    undefined -> memsup:start_link();
    _ -> already_started
  end,
  
  started.

cluster_nodes() ->
  [node() | nodes()].
  
cluster_call_function(Module, Function, Parameters) ->
  {Results, _} = rpc:multicall(cluster_nodes(), Module, Function, Parameters, ?TIMEOUT),
  
  Results.
  
get_node_load() ->
  {{node, node()}, {load, cpu_sup:avg1()}}.
  
get_cluster_load() ->
  _ClusterLoad = cluster_call_function(system_info, node_load, []).
  
get_node_processes() ->
  {{node, node()}, {processes, cpu_sup:nprocs()}}.
  
get_cluster_processes() ->
  _ClusterProcesses = cluster_call_function(system_info, node_processes, []).
  
get_node_memory() ->
  [{total_memory, NodeTotalMemory},
   {free_memory, NodeFreeMemory},
   {system_total_memory, OSTotalMemory}] = memsup:get_system_memory_data(),
  
  {_, NodeAllocatedMemory, NodeLargestProcess} = memsup:get_memory_data(),
  
  {{node, node()},
   {memory, {{os_total_memory, OSTotalMemory},
             {node_total_memory, NodeTotalMemory},
             {node_allocated_memory, NodeAllocatedMemory},
             {node_free_memory, NodeFreeMemory},
             {node_largest_process, NodeLargestProcess}}}}.
             
get_cluster_memory() ->
  _ClusterMemory = cluster_call_function(system_info, node_memory, []).
  