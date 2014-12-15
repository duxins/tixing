var TixingBridge = (function(){
  var version = 1.1;
  var scheme = 'tixing-action://';
  var callbacksCount = 0;
  var callbackPrefix = 'TixingCallback'

  function createIframe(src) {
    var iframe = document.createElement("iframe");
    iframe.setAttribute("src",src);
    iframe.style.display = 'none';
    document.body.appendChild(iframe);
  }

  function createCallback(callback){
    var name = callbackPrefix + callbacksCount;
    window[name] = callback;
    callbacksCount ++;
    return name
  }

  return {
    getVersion: function(){
      return version;
    },
    callFunction: function(action, parameters, callback){
      parameters = parameters || {}
      callback = callback || ''

      if (typeof callback == 'function') {
        callback = createCallback(callback)
      }

      parameters.callback = callback;

      var url = scheme + action + '/?' + JSON.stringify(parameters);
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

  bridge.getAppVersion = function(callback){
    this.callFunction('appVersion', null, callback);
  }
})(TixingBridge);

//Service
(function(bridge){
  bridge.uninstallService = function(){
    this.callFunction('uninstallService');
  }
})(TixingBridge);

//Media
(function(bridge){
  bridge.playSound = function(name){
    this.callFunction('playSound', {'name': name});
  }
 
  bridge.scanQRCode = function(callback){
    this.callFunction('scanQRCode', null, callback);
  }
})(TixingBridge);

document.dispatchEvent(new Event('bridge:ready'));
