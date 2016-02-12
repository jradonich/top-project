userModule = angular.module 'user', ["localService", "ngFileUpload"]

userModule.constant('saveNS', 'toptalUser')

userModule.controller 'UserController', ['$scope', '$timeout', 'User', '$rootScope', 'Upload', '$window',
  ($scope, $timeout, user, $rootScope, Upload, $window) ->

    $scope.$watch('user.location', (newValue, oldValue) ->
      if newValue isnt oldValue
        console.log("user location changed.  Broadcasting", newValue)
        $rootScope.$broadcast('location-set', newValue)
    , true)

    $scope.currentSkill = {}
    isEditingCurrentSkill = false

    $scope.editSkill = (skillToEdit) ->
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


    $scope.hasResume = () ->
      return $scope.user.resume and $scope.user.resume.length

    addResume = (resume) ->
      if not $scope.hasResume()
        $scope.user.resume = []

      $scope.user.resume.push(resume)

    $scope.openFile = (file) ->
      $window.open(file.url, '_blank')

    $scope.upload = (type, validFiles, invalidFiles) ->
      if type == 'resume'
        if validFiles? and validFiles.length
          file = validFiles[0]
          Upload.dataUrl(file, true).then((url) ->
            resume = {
              name: file.name
              url: url
            }
            console.log("adding resume", resume)
            addResume(resume)
          )
#      else if type == 'image'

    $scope.loadImageFile = (file) ->
      if file? and file.length
        Upload.dataUrl(file[0], true).then((url) ->
          $scope.user.image = url
        )
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
