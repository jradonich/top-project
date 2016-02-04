describe 'Content', () ->

  conTypes = undefined

  beforeEach module 'toptalProject'
  beforeEach module 'content'

  beforeEach inject (contentTypes, map) ->
    conTypes = contentTypes


  it('should return a content type object based on no provided type (default case)', ()->
    typeInstance = new conTypes()
    expect(typeInstance.type).toEqual('text')
  )

  it('should return a content type object based on provided type', () ->
    typeInstance = new conTypes('map')
    expect(typeInstance.type).toEqual('map')

    typeInstance = new conTypes('file')
    expect(typeInstance.type).toEqual('file')
  )

  it('should validate a map type by making call to google map service', () ->
    typeInstance = new conTypes('map')
    typeInstance.validate('Tacoma, WA').then()

  )
