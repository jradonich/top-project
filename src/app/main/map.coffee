mapsModule = angular.module("map", [])
mapsModule.constant('apiKey', 'AIzaSyAv5aSwUN_FVfj4e-WqUGCvvzhX9Z7xihY')

mapsModule.directive('location', ['mapService', (map)->
  'ngInject'
  return {
    restrict: 'EA'
    scope:
      location: "="
    templateUrl: "app/partials/location-directive.html"
    link: (scope, element, attrs) ->

      currentLocation = scope.location

      scope.checkLocation = (formLoc) ->
        validateResults = map.validate(formLoc)
#        scope.isValidating = true
        return validateResults.then((location) ->
          valid = location?
          console.log("location validation [is valid: #{valid}]", location)
          currentLocation = location.formatted_address
          return valid
        )
      scope.updateLocation = () ->
        scope.location = currentLocation
        return
  }
])

mapsModule.factory('mapService', ['$q', 'apiKey', ($q, apiKey) ->
  geo = new google.maps.Geocoder()
  previousLookup = undefined

  ###
    Google results of type 'locality' are used to distinguish a city
  ###
  getCityFromResults = (locationResults) ->
    cityLocation = undefined

    locationResults.forEach((location, i) ->
      tmpLocation = (location for locType in location.types when locType is 'locality')
      if tmpLocation
        cityLocation = tmpLocation[i]
        return
    )
    console.log "found city", cityLocation
    return cityLocation

  service = {
    validate: (location) ->
      defer = $q.defer()

      geo.geocode({address: location}, (result) ->
        console.log "map validate results", result
        validatedCity = getCityFromResults(result)
        previousLookup = validatedCity
        if validatedCity
          defer.resolve(validatedCity)
        else
          defer.reject("Not a valid location")
      )
      return defer.promise

    display: (element) ->
      location = previousLookup.geometry.location
      return service.getImageUrl(location)

    getImageUrl: (location) ->
      lat = location.lat()
      lon = location.lng()
      url = "https://maps.googleapis.com/maps/api/staticmap?center=#{lat},#{lon}&zoom=11&size=200x200&key=#{apiKey}"
      console.log(url)
      return url

  }
  return service
])


