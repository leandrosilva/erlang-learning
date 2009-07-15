%%
%% The yawsapp.hrl file would be were we defined any records or global constants used by our
%% application. In this application, we have three constants that are used to define the behavior
%% of the supervisor tree
%%
-define(MAX_RESTART, 5).
-define(MAX_TIME, 60).
-define(SHUTDOWN_WAITING_TIME, 2000).