describe 'controllers', () ->
  vm = undefined

  beforeEach module 'toptalProject'

  beforeEach inject ($controller, webDevTec, toastr) ->
    spyOn(webDevTec, 'getTec').and.returnValue [{}, {}, {}, {}, {}]
    spyOn(toastr, 'info').and.callThrough()
    vm = $controller('MainController', { $scope: {} })

  it 'should have a timestamp creation date', () ->
    expect(vm.creationDate).toEqual jasmine.any Number


  it 'should show a Toastr info and stop animation when invoke showToastr()', inject (toastr) ->
    vm.showToastr()
    expect(toastr.info).toHaveBeenCalled()
    expect(vm.classAnimation).toEqual ''

