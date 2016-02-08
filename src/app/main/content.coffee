contentModule = angular.module 'content', ['map']

contentModule.controller('ContentController', ['$scope', ($scope) ->
  'ngInject'

  sections =
    portfolio:
      name: "Portfolio"
      type: 'list'
      listLeftPlaceholder: "Project Name"
      listRightPlaceholder: "Skills Used"
    experience:
      name: "Experience"
      type: 'list'
    sampleCodeAndAlgorithms:
      name: "Sample code and algorithms"
    availability:
      name: "Availability"
      type: 'availability'
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
      notFromUser: true


  tmpSections = {}
  _.forEach(sections, (section, prop, obj) ->
    tmpSections[prop] = {
      layout: angular.extend({}, section)
    }
  )

  console.log("$scope.user in ContentController", $scope.user)
  if $scope.user.content?
    _.forEach(tmpSections, (section, key) ->
      if not section.data
        section.data = {}


      cur = $scope.user.content[key]
      console.log "section - #{key}"
      if cur
        console.log("found value for #{key}", cur)
        section.data = cur
      else
        section.data = $scope.user.content[key] = {data:""}

    )
    console.log("sections after loop", tmpSections)
    console.log("$scope.user after for loop", $scope.user.content)
    $scope.sections = tmpSections

  $scope.$on('user.content.portfolio', (newVal, oldVal) ->
    console.log('user.content.portfolio changed', arguments)
  , true)

  $scope.mySections = [

  ]

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
      @inputType = "map"

    validate: (location) ->
      con = @content
      console.log("Validate() #{con}")
      #noinspection JSUnresolvedVariable
      mapService.validate(location)

    render: (element) ->
      #noinspection JSUnresolvedVariable
      mapService.display(element)
    loadContent: () ->

  class ListContentType extends ContentType
    @columns = 2
    constructor: () ->
      super("list")
      @inputType = "list"


  class FileContentType extends ContentType
    constructor: () ->
      super("file")

  class AvailabilityType extends ContentType
    constructor: () ->
      @options = ["Full-Time", "Part-Time"]
      @inputType = "availability"

  class ContentTypeBuilder
    constructor: (type) ->
      if type is "map"
        return new MapContentType()
      else if type is "file"
        return new FileContentType()
      else if type is "availability"
        return new AvailabilityType()
      else if type is "list"
        return new ListContentType()
      else
        return new ContentType()


  return ContentTypeBuilder
])

contentModule.directive 'contentItem', ['contentTypes', '$rootScope', 'User',
  (contentTypes, $rootScope, User)->
    'ngInject'
    return {
      restrict: 'EA'
      scope:
        layout: '=content'
        model: '=contentMod'
      templateUrl: "app/partials/content-item-directive.html"
      link: (scope, element, attrs) ->
        layoutObj = scope.layout
        if layoutObj.type
          console.log("Scope.content - #{layoutObj.type}", layoutObj)
        else
          console.log("Scope.content - default", layoutObj)

        typeObject = new contentTypes(layoutObj.type)
        scope.template = "app/partials/content-item-types/#{typeObject.inputType || 'default'}.html"
        console.log("\ttypeObject", typeObject)
        scope.layout.inputType = typeObject.inputType || ""
        scope.isEditing = false

        scope.user = User

        if typeObject.options?
          scope.options = typeObject.options
          scope.getRadioValue = (item) ->
            return item

        scope.containerClick = () ->
          scope.isEditing = true

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

        if scope.layout.updateOnEvent
          $rootScope.$on(scope.layout.updateOnEvent, (newVal) ->
            scope.model.url = typeObject.render()
          )
    }
]

