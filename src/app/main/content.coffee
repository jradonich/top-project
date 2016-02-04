contentModule = angular.module 'content', ['map']

contentModule.controller('ContentController', ['$scope', ($scope) ->
  'ngInject'

  $scope.sections =
    portfolio:
      name: "Portfolio"
    experience:
      name: "Experience"
    sampleCodeAndAlgorithms:
      name: "Sample code and algorithms"
    availability:
      name: "Availability"
    mostAmazing:
      name: "The most amazing..."
      defaultContent: "Tell us about the best software you have worked on..."
    clients:
      name: "In clients I look for..."
      defaultContent: "Tell us about what you look for in a client..."
    location:
      name: "Location"
      type: "map"
      updateOnEvent: 'location-set'
    note:
      name: "Note"


  $scope.mySections = []

])

contentModule.directive 'contenteditablemod', ->
  return {
    require: 'ngModel'
    transclude: true
    template: '<div ng-transclude></div>'
    link: (scope, elm, attrs, ctrl) ->
      # view -> model
      elm.on 'blur', ->
        ctrl.$setViewValue elm.html()
        return
      # model -> view

      ctrl.$render = ->
        elm.html ctrl.$viewValue
        return

      # load init value from DOM
      ctrl.$setViewValue elm.html()
      return
  }


contentModule.factory('contentTypes', ["mapService", "$q", (mapService, $q) ->
  class ContentType
    constructor: (@type="text", @content="") ->
      @inputType = ""

    addContent: (content) ->
      @content = content

    validate: () ->
      $q.when(true)

    render: () ->

    loadContent: () ->
      return @content

  class MapContentType extends ContentType
    constructor: (@type, @content) ->
      super("map", @content)
      @inputType = "text"

    validate: (location) ->
      con = @content
      console.log("Validate() #{con}")
#      isValid = true
      mapService.validate(location)

    render: (element) ->
      mapService.display(element)
    loadContent: () ->


  class FileContentType extends ContentType
    constructor: () ->
      super("file")

  class ContentTypeBuilder
    constructor: (type) ->
      if type is "map"
        return new MapContentType()
      else if type is "file"
        return new FileContentType()
      else
        return new ContentType()


  return ContentTypeBuilder
])

contentModule.directive 'contentItem', ['contentTypes', (contentTypes)->
  'ngInject'
  return {
    restrict: 'EA'
    scope:
      model: '=content'
    templateUrl: "app/partials/content-item-directive.html"
    link: (scope, element, attrs) ->
      if scope.model.type
        console.log("Scope.content - #{scope.model.type}", scope.model)
      else
        console.log("Scope.content - default", scope.model)

      typeObject = new contentTypes(scope.model.type)
      console.log("\ttypeObject", typeObject)
      scope.model.inputType = typeObject.inputType || ""
      scope.isEditing = false

      scope.onContentElementShow = () ->
        scope.isEditing = true

      scope.bodyClick = () ->
        scope.isEditing = false
        console.log("clicked #{scope.model.name} - ", typeObject)

        if !scope.isEditing
          console.log("No longer editing.  Will try validate value: #{scope.model.data}")
          if scope.model.data
            typeObject.validate(scope.model.data).then((isValid) ->
              console.log "validation complete: #{isValid}"
              if isValid
                scope.model.url = typeObject.render()
            )

      if scope.model.updateOnEvent
        console.log("scope.user", scope.user)
        scope.$on(scope.model.updateOnEvent, (newVal) ->
          console.log("UPDATED", newVal)
        )
  }
]

