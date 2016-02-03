angular.module 'toptalProject'
  .controller 'MainController', ($scope, $timeout, webDevTec, toastr, User) ->
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
    originalUser = angular.copy(User.model)
    $scope.user = User.model




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
