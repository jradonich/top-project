userModule = angular.module 'user', ["localService", "ngFileUpload"]

userModule.constant('saveNS', 'toptalUser')
userModule.value("defaultUser", {
  availability:
    status: "Full Time"
})

userModule.controller 'UserController', ['$scope', '$timeout', 'User', '$rootScope', 'defaultUser',
  ($scope, $timeout, user, $rootScope, defaultUser) ->
    user.init()
    $scope.user = angular.extend(defaultUser, user.model)

    $scope.$watch('user.location', (newValue, oldValue) ->
      if newValue isnt oldValue
        console.log("user location changed.  Broadcasting", newValue)
        $rootScope.$broadcast('location-set', newValue)
    , true)

    $scope.currentSkill = {}

    focusOnInput = ->
      $('.addASkillContainer input').focus()

    $scope.addSkill = ->
      $scope.isAddingSkill = true
      $scope.currentSkill =
        skillLevel: "Expert"
      $scope.skillCurrentlyBeingAdded =
        skillLevel: "Expert"
      $timeout(focusOnInput, 0)


    $scope.addCurrentSkill = (skill) ->
      if not $scope.user.skills
        $scope.user.skills = []
      skill.skillClass = "skill-#{skill.skillLevel.toLowerCase()}"
      $scope.user.skills.push(skill)

      $scope.isAddingSkill = false
      $scope.skillCurrentlyBeingAdded = {}

    $scope.loadImageFile = (file) ->
      if file? and file.length
        console.log("handle image selected", file[0])
        $scope.user.image = file[0].$ngfBlobUrl
  ]


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
