%%
%% Thanks to Socklabs Blog: http://blog.socklabs.com/2008/02/08/embedded_applications_with_yaw.html
%%
%% The application configure, as seen in listing 1-1, is pretty basic. We define the application,
%% its related modules and set a few environmental variables. The working_dir variable is used to
%% determine where the yaws log and tmp directory will be located.
%%
{application, yawsapp,
 [{description, "An embedded yaws application example."},
  {vsn, "0.1"},
  {modules, [yawsapp, yawsapp_sup, yawsapp_server]},
  {registered, [yawsapp]},
  {env, [
    {port, 8006},
    {working_dir, "/Users/leandro/Projects/erlang/yaws_app/"}
  ]},
  {applications, [kernel, stdlib, sasl]},
  {mod, {yawsapp, []}}
 ]}.