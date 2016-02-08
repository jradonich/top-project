describe 'User', () ->

  describe "Service", () ->

    user = undefined
    localStore = undefined
    mapServ = undefined

    beforeEach module 'toptalProject'
    beforeEach module 'localService'
    beforeEach module 'user'
    beforeEach module 'map'

    afterAll ->
      localStore.clear()

    beforeEach inject (User, localService, saveNS, mapService) ->
      saveNS = "Test-USER"
      user = User
      mapServ = mapService
      localStore = localService
      spyOn(user, 'init').and.callThrough()
      spyOn(user, 'load').and.callThrough()
      spyOn(localStore, 'set').and.callThrough()
      spyOn(localStore, 'get').and.callThrough()
      return

    it 'should create a user', ->
      expect(user.save).toEqual(jasmine.any(Function))
      expect(user.load).toEqual(jasmine.any(Function))
      expect(user.init).not.toHaveBeenCalled()
      expect(user.load).not.toHaveBeenCalled()

    it 'should create a user and initialize', ->
      expect(user.save).toEqual(jasmine.any(Function))
      expect(user.load).toEqual(jasmine.any(Function))
      model = user.init()
      expect(user.load).toHaveBeenCalled()
      expect(user.init).toHaveBeenCalled()
      expect(model).toEqual({})
      expect(user.model).toEqual(model)


    it 'should save a user', ->
      actualModel =
        name: 'John Smith'
        languages: ['English']
        location: 'Seattle, WA'

      user.init()
      user.model = actualModel

      #Save user
      user.save()
      expect(localStore.set).toHaveBeenCalled()

      #clear model and reload from local store
      user.model = {}
      reloadedModel = user.load()
      expect(actualModel).toEqual(reloadedModel)
      expect(user.model).toEqual(reloadedModel)


    it 'should only init one time (load cached model for subsequent init()s)', ->
      user.init()
      user.model =
        id: 1
      expect(localStore.get.calls.count()).toBe(1)
      expect(user.model).toEqual({id: 1})

      user.init()

      #make sure localstore get still only called once
      expect(localStore.get.calls.count()).toBe(1)
      expect(user.model).toEqual({id: 1})

    it "it should get the user's first name", ->
      user.init()
      user.model.name = "John Smith"
      expect(user.getFirstName()).toEqual("John")

      user.model.name = "John"
      expect(user.getFirstName()).toEqual("John")

      user.model.name = ""
      expect(user.getFirstName()).toEqual("")

      delete user.model.name
      expect(user.getFirstName()).toEqual("")

      user.model.name = "John Smith Smith2"
      expect(user.getFirstName()).toEqual("John")

