angular.module "localService", []
  .constant('localNamespace', 'topLocal')
  .factory "localService", ['$window', 'localNamespace', ($win, localNamespace)->

    namespace = localNamespace
    store = $win.localStorage

    namespaceKey = (key) ->
      return "#{namespace}-#{key}"

    addToLocal = (key, value) ->
      store.setItem(namespaceKey(key), value)
      return

    getFromLocal = (key) ->
      store.getItem(namespaceKey(key))

    addImage = (key, image) ->
      console.log "do something"

    clear = () ->
      store.clear()

    return {
      set: addToLocal
      get: getFromLocal
      addImage: addImage
      clear: clear
    }
]
