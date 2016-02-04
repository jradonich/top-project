userModule = angular.module 'user', ["localService"]

userModule.controller 'UserController', ['$scope', 'User', ($scope, user) ->
  user.init()
  $scope.user = user.model

  $scope.$watch('user.location', (newValue, oldValue) ->
    if newValue isnt oldValue
      console.log("user location changed.  Broadcasting", newValue)
      $scope.$broadcast('location-set', newValue)
  , true)

  $scope.currentSkill = {}

  $scope.addSkill = ->
    $scope.isAddingSkill = true
    $scope.currentSkill =
      skillLevel: "Expert"
    $scope.skillCurrentlyBeingAdded =
      skillLevel: "Expert"


  $scope.addCurrentSkill = (skill) ->
    if not $scope.user.skills
      $scope.user.skills = []
    skill.skillClass = "skill-#{skill.skillLevel.toLowerCase()}"
    $scope.user.skills.push(skill)

    $scope.isAddingSkill = false
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
