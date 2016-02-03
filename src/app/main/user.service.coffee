#angular.module "user", ["localService"]
#  .constant('saveNS', 'toptalUser')
#  .factory "User", ['localService', 'saveNS', (localService, saveNS) ->
#    'ngInject'
#
#    userSaveProperty = saveNS
#    user = {}
#
#    user.init = ->
#      user.model = user.load() || {}
#
#    user.save = ->
#      localService.set(userSaveProperty, JSON.stringify(user.model))
#
#    user.load = ->
#      user.model = JSON.parse(localService.get(userSaveProperty))
#      return user.model
#
#    return user
#]
