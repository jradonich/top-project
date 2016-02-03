userModule = angular.module 'user', ["localService"]

userModule.controller 'UserController', ['$scope', 'User', ($scope, user) ->
  user.init()
  $scope.user = user.model
  console.log("UserController $scope", $scope.user)
]

userModule.constant('saveNS', 'toptalUser')

userModule.factory "User", ['localService', 'saveNS', (localService, saveNS) ->
  'ngInject'

  userSaveProperty = saveNS
  user = {}

  user.init = ->
    if typeof user.model is 'undefined' then user.model = user.load() || {}
    return user.model

  user.save = ->
    localService.set(userSaveProperty, JSON.stringify(user.model))

  user.load = ->
    user.model = JSON.parse(localService.get(userSaveProperty))
    return user.model

  return user
]
