-module(system_info_test).

-include_lib("eunit/include/eunit.hrl").

node_load_test() ->
  MachineLoad = system_info:node_load(),
  
  ?assertMatch({{node, _}, {load, _}}, MachineLoad).
  
cluster_load_test() ->
  ClusterLoad = system_info:cluster_load(),
  [FirstMachineLoad | _] = ClusterLoad,
  
  ?assertMatch({{node, _}, {load, _}}, FirstMachineLoad).
  
node_processes_test() ->
  MachineProcesses = system_info:node_processes(),
  
  ?assertMatch({{node, _}, {processes, _}}, MachineProcesses).
  
cluster_processes_test() ->
  ClusterProcesses = system_info:cluster_processes(),
  [FirstMachineProcesses | _] = ClusterProcesses,
  
  ?assertMatch({{node, _}, {processes, _}}, FirstMachineProcesses).
  
node_memory_test() ->
  MachineMemory = system_info:node_memory(),
  
  ?assertMatch({{node, _},
                {memory, {{os_total_memory, _},
                          {node_total_memory, _},
                          {node_allocated_memory, _},
                          {node_free_memory, _},
                          {node_largest_process, _}}}},
               MachineMemory).
               
cluster_memory_test() ->
  ClusterMemory = system_info:cluster_memory(),
  [FirstClusterMemory | _] = ClusterMemory,
  
  ?assertMatch({{node, _},
                {memory, {{os_total_memory, _},
                          {node_total_memory, _},
                          {node_allocated_memory, _},
                          {node_free_memory, _},
                          {node_largest_process, _}}}},
               FirstClusterMemory).
               