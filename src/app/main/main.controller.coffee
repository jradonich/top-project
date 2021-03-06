angular.module 'toptalProject'
  .controller 'MainController', ($scope, $timeout, webDevTec, toastr, User, defaultUser) ->
    'ngInject'
    vm = this

    activate = ->
      getWebDevTec()
      $timeout (->
        vm.classAnimation = 'rubberBand'
        return
      ), 4000
      return

    showToastr = ->
      toastr.info 'Fork <a href="https://github.com/Swiip/generator-gulp-angular" target="_blank"><b>generator-gulp-angular</b></a>'
      vm.classAnimation = ''
      return

    getWebDevTec = ->
      vm.awesomeThings = webDevTec.getTec()
      angular.forEach vm.awesomeThings, (awesomeThing) ->
        awesomeThing.rank = Math.random()
        return
      return


    User.init()

    originalUser = angular.extend({}, defaultUser, User.model)
    originalUser = angular.copy(originalUser)
    $scope.userObj = User

    $scope.user

    $scope.user = User.model

    $scope.isReadOnly = false

    # handler for Save Profile button
    $scope.updateProfile = () ->
      User.save()
      originalUser = angular.copy(User.model)

    $scope.isProfileComplete = () ->
      return false

    $scope.hasChanged = ->
      return angular.equals(originalUser, $scope.user)



    vm.awesomeThings = []
    vm.classAnimation = ''
    vm.creationDate = 1454342454786
    vm.showToastr = showToastr
    activate()
    return
