describe 'localStore', () ->

  locStore = undefined

  beforeEach module 'toptalProject'
  beforeEach module 'localService'

  addSomeItems = ->
    locStore.set item, item for item in ['1', '2', '3']

  afterEach ->
    locStore.clear

  beforeEach inject (localService, localNamespace) ->
    localNamespace = "TESTNAMESPACE"
    locStore = localService

  afterEach ->
    locStore.clear

  it('should create local store with get, set functions', ()->
    expect(locStore.get).toEqual(jasmine.any(Function))
    expect(locStore.set).toEqual(jasmine.any(Function))
    expect(locStore.addImage).toEqual(jasmine.any(Function))
    expect(locStore.clear).toEqual(jasmine.any(Function))
  )

  it 'should add items to store', ->
    addSomeItems()
    expect(locStore.get(item, item)).toEqual(item) for item in ['1', '2', '3']

  it 'should clear all items added from the store', ->
    addSomeItems()

    locStore.clear()
    expect(locStore.get('1')).toBeNull()
    expect(locStore.get('2')).toBeNull()
    expect(locStore.get('3')).toBeNull()

  it 'should get items from the store', ->
    addSomeItems()
    expect(locStore.get(item, item)).toEqual(item) for item in ['1', '2', '3']
