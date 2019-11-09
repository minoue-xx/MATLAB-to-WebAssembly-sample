%% step1
proj = webcoder.setup.project("optimizePosition","Directory",pwd,"OutputType",'dll');
%% step2
proj = openProject(pwd);
webcoder.build.project(proj);

%% step3
% on dist folder
server = webcoder.utilities.DevelopmentServer("Port",8125);
start(server);
web('http://10.0.1.14:8125')
%%
stop(server);