{application, webmachineapp,
 [{description, "webmachineapp"},
  {vsn, "0.1"},
  {modules, [
    webmachineapp,
    webmachineapp_app,
    webmachineapp_sup,
    webmachineapp_deps,
    webmachineapp_resource
  ]},
  {registered, []},
  {mod, {webmachineapp_app, []}},
  {env, []},
  {applications, [kernel, stdlib, crypto]}]}.
