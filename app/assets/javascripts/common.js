function loadPageSpecificJs(controllerName, actionNames, jsModule) {
  var controllers = {};
  controllers[controllerName] = actionNames;
  load({controllers: controllers}, function () {
    jsModule();
  });
}