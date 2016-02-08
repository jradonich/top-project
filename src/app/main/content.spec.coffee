describe 'Content', () ->

  conTypes = undefined
  google = undefined
  mapServ = undefined

  beforeEach module 'toptalProject'
  beforeEach module 'content'
  beforeEach module 'map'


  beforeEach inject (contentTypes, mapService) ->
    conTypes = contentTypes
    google = {}
    mapServ = mapService


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

#  it('should validate a map type by making call to google map service', () ->
#    typeInstance = new conTypes('map')
#    typeInstance.validate('Tacoma, WA').then()
#
#  )
