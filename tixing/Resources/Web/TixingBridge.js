var TixingBridge = (function(){
  var version = 1.0;
  var scheme = 'tixing-action://';

  function createIframe(src) {
    var iframe = document.createElement("iframe");
    iframe.setAttribute("src",src);
    iframe.style.display = 'none';
    document.body.appendChild(iframe);
  }

  return {
    getVersion: function(){
      return version;
    },
    callFunction: function(action, parameters, callback){
      parameters = parameters || {};
      callback = callback || '';
      //TODO: Support real callback function
      parameters['callback'] = callback;
      var url = scheme + action + '/?' + JSON.stringify(parameters)
      createIframe(url);
    }
  };
})();

//Basic
(function(bridge){
  bridge.goBack = function(){
    this.callFunction('goBack');
  }

  bridge.alert = function(message){
    this.callFunction('alert', {'message': message});
  }
})(TixingBridge);

//Service
(function(bridge){
  bridge.uninstallService = function(){
    this.callFunction('uninstallService');
  }
})(TixingBridge);

//Sound
(function(bridge){
  bridge.playSound = function(name){
    this.callFunction('playSound', {'name': name});
  }
})(TixingBridge);

