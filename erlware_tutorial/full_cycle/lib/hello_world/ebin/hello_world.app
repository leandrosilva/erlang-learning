%% This is the application resource file (.app file) for the hello_world,
%% application.
{application, hello_world, 
  [{description, "Say hello to the world"},
   {vsn, "0.1.0"},
   {modules, [hello_world_app,
              hello_world_sup,
              hello_world_server]},
   {registered,[hello_world_sup]},
   {applications, [kernel, stdlib]},
   {mod, {hello_world_app,[]}},
   {start_phases, []}]}.

