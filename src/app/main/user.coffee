userModule = angular.module 'user', ["localService", "ngFileUpload"]

userModule.constant('saveNS', 'toptalUser')
userModule.value("defaultUser", {
  content:
    availability:
      data:
        status: "Full-Time"
})

userModule.controller 'UserController', ['$scope', '$timeout', 'User', '$rootScope', 'defaultUser',
  ($scope, $timeout, user, $rootScope, defaultUser) ->

    $scope.$watch('user.location', (newValue, oldValue) ->
      if newValue isnt oldValue
        console.log("user location changed.  Broadcasting", newValue)
        $rootScope.$broadcast('location-set', newValue)
    , true)

    $scope.currentSkill = {}
    isEditingCurrentSkill = false

    $scope.editSkill = (skillToEdit, index) ->
      $scope.addSkill(skillToEdit)
      isEditingCurrentSkill = true

    resetSkill = ->
      isEditingCurrentSkill = false
      $scope.isAddingSkill = false
      $scope.skillCurrentlyBeingAdded = {}

    addEscKeyBind = ->
      formElement = $('.skill-form')
      formElement.off()
      formElement.on('keyup', (evt) ->
        if evt.keyCode == 27 #Esc key
          console.log("Hiding", formElement)
          $timeout(resetSkill, 1)
      )

    focusOnInput = ->
      $('.addASkillContainer input').focus()
      addEscKeyBind()

    $scope.addSkill = (skill) ->
      $scope.isAddingSkill = true
      $scope.currentSkill =
        skillLevel: "Expert"
      $scope.skillCurrentlyBeingAdded =
        skillLevel: "Expert"
      if skill
        $scope.currentSkill= skill
        $scope.skillCurrentlyBeingAdded = skill
      $timeout(focusOnInput, 0)

    $scope.removeSkill = (index) ->
      $scope.user.skills.splice(index, 1)

    $scope.addCurrentSkill = (skill) ->
      if not skill.skillName
        resetSkill()
        return

      if not $scope.user.skills
        $scope.user.skills = []
      skill.skillClass = "skill-#{skill.skillLevel.toLowerCase()}"

      if not isEditingCurrentSkill
        $scope.user.skills.push(skill)

      resetSkill()

      #refocus button after a digest completes so we can click enter or space to easily add another skill
      $timeout(->
        angular.element('button.addSkill').focus()
      , 0)

    $scope.editImage = () ->
      $timeout(
        angular.element('button.load-user-image').click()
      , 0)

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

  user.getUsername = ->
    return user.init().name


  user.save = ->
    console.log("saving ", user.model)
    localService.set(userSaveProperty, JSON.stringify(user.model))

  user.load = ->
    user.model = JSON.parse(localService.get(userSaveProperty))
    console.log("loaded user", user.model)
    return user.model

  user.getFirstName = ->
    uName = user.getUsername() || ""
    return uName.split(' ')[0]

  return user
]
