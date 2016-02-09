mapsModule = angular.module("map", ['content'])
mapsModule.constant('apiKey', 'AIzaSyAv5aSwUN_FVfj4e-WqUGCvvzhX9Z7xihY')

mapsModule.directive('location', ['mapService', '$rootScope', 'User', (map, $rootScope, User)->
  'ngInject'
  return {
    restrict: 'EA'
    scope:
      location: "="
      showMap: "="
    templateUrl: "app/partials/location-directive.html"
    link: (scope, element, attrs) ->
#      map = new MapContentType()
      locationName = ""
      currentLocation = scope.location
      console.log("location directive", scope.showMap)

      scope.checkLocation = (formLoc) ->
        validateResults = map.validate(formLoc)
#        scope.isValidating = true
        return validateResults.then((location) ->
          valid = location?
          console.log("location validation [is valid: #{valid}]", location)
          currentLocation = location.formatted_address
          return valid
        )

      scope.getText = () ->
        name = User.getFirstName()
        loc = map.getFormattedAddress()
        text = "#{name} lives in #{loc}"

      updateLocation = () ->
        scope.url = map.display(element)
        scope.fullUrl = map.getFullMapUrl()
        console.log("Update location", [scope.url, scope.fullUrl])
        if scope.showMap
          $(element).parents('.content-item').find('.panel-head').hide()

      $rootScope.$on('location-set', (newLocationValue) ->
        console.log("location-set", newLocationValue)
        currentLocation = newLocationValue
        if scope.showMap
          updateLocation()
      )

      scope.updateLocation = () ->
        console.log("scope.updateLocation()", currentLocation)
        scope.location = currentLocation
        if scope.showMap
          updateLocation()
        return
  }
])

mapsModule.factory('mapService', ['$q', 'apiKey', ($q, apiKey) ->
  geo = if google? then new google.maps.Geocoder() else {}
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
      if element?
#        debugger
        size = [element.innerWidth(), 200]
        size = "#{size[0]}x#{size[1]}"
      return service.getImageUrl(location, size)

    getImageUrl: (location, size) ->
      lat = location.lat()
      lon = location.lng()
      if not size
        size = "200x200"
      url = "https://maps.googleapis.com/maps/api/staticmap?center=#{lat},#{lon}&zoom=11&size=#{size}&key=#{apiKey}"
      console.log(url)
      return url

    getFullMapUrl: () ->
      location = previousLookup.geometry.location
      lat = location.lat()
      long = location.lng()
      return "https://www.google.com/maps/@#{lat},#{long},11z"

    getFormattedAddress: () ->
      return if previousLookup? then previousLookup.formatted_address else ""
  }
  return service
])


