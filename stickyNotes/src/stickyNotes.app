{application, stickyNotes,
 [{description, "stickyNotes"},
  {vsn, "0.01"},
  {modules, [
    stickyNotes,
    stickyNotes_app,
    stickyNotes_sup,
    stickyNotes_web,
    stickyNotes_deps
  ]},
  {registered, []},
  {mod, {stickyNotes_app, []}},
  {env, []},
  {applications, [kernel, stdlib, crypto]}]}.
