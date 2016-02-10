contentModule = angular.module 'content', ['map']

contentModule.controller('ContentController', ['$scope', ($scope) ->
  'ngInject'

  sections =
    portfolio:
      name: "Portfolio"
      type: 'list'
      placeholders: ['Project Name', 'Skills Used']
      subhead: true
    experience:
      name: "Experience"
      type: 'list'
      placeholders: ['Skill', 'Years of Experience']
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
  _.forEach(sections, (section, prop) ->
    tmpSections[prop] = {
      layout: angular.extend({}, section)
    }
  )

  $scope.mySections = _.times(4, ()->
    return {
      layout: ''
    }
  )

  console.log("$scope.user in ContentController", $scope.user)
  if $scope.user.content?
    _.forEach(tmpSections, (section, key) ->
      if not section.data
        if section.layout.type == 'list'
          section.data = []
        else
          section.data = {}


      cur = $scope.user.content[key]
      console.log "section - #{key}",
      if cur
        console.log("\tfound value for #{key}", cur)
        section.data = cur
      else
        section.data = $scope.user.content[key]

    )
    console.log("sections after loop", tmpSections)
    console.log("$scope.user after for loop", $scope.user.content)
    $scope.sections = tmpSections



])

contentModule.directive 'contenteditable', [
  '$sce'
  ($sce) ->
    {
      restrict: 'A'
      require: '?ngModel'
      link: (scope, element, attrs, ngModel) ->
        #haven't figured out a better way to do this.  Was clearing out model causing issues.
        hasLoaded = false
        read = ->
          html = element.html()
          # When we clear the content editable the browser leaves a <br> behind
          # If strip-br attribute is provided then we strip this out
          if attrs.stripBr and html == '<br>'
            html = ''
          if html or hasLoaded
            hasLoaded = true
            ngModel.$setViewValue html
          return

        if !ngModel
          return
        # do nothing if no ng-model
        # Specify how UI should be updated

        ngModel.$render = ->
          element.html $sce.getTrustedHtml(ngModel.$viewValue or '')
          return

        # Listen for change events to enable binding
        element.on 'blur keyup change', ->
          scope.$evalAsync read
          return
        read()
        return

    }
]

contentModule.factory('contentTypes', ["mapService", "$q", "User", (mapService, $q, User) ->
  class ContentType
    constructor: (@type="text", @content="") ->
      @inputType = ""
      @defaultValue = ""

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
#      mod = User.init()

  class ListContentType extends ContentType
    @columns = 2

    constructor: () ->
      super("list")
      @inputType = "list"
      @defaultValue = [{
        key: ""
        value: ""
      }]
      @listItemObj =
        key: ""
        value: ""



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

contentModule.directive('list', ['$timeout', ($timeout)->
  'ngInject'
  return {
    restrict: 'EA'
    require: '^contentItem'
    scope:
      list: '='
    templateUrl: "app/partials/list-directive.html"
    link: (scope, element, attrs, contentItemCtrl) ->
      wasKeyDownTab = undefined
      layout = contentItemCtrl.layout

      masterData = angular.copy(scope.list)

      scope.inputPlaceholders =
        left: layout.placeholders[0] or ""
        right: layout.placeholders[1] or ""

      scope.hasContent = () ->
        if scope.list.length == 0
          return false
        if scope.list.length > 1
          return true
        else
          return _.some(scope.list, 'key')

      element.on('keydown', (evt)->
        isTab = evt.keyCode == 9 and not evt.shiftKey #ignore 'back' tab
        isLast = $(evt.target).hasClass('last')
        isEnter = evt.keyCode == 13

        if isLast and isTab
          evtElement = $(evt)
          wasKeyDownTab = true
          scope.list.push(angular.copy(contentItemCtrl.type.listItemObj))
          scope.$apply(->
            evtElement.next('tr td').focus()
          )

        if isEnter
          evt.preventDefault()
      )

      element.on('keyup', (evt) ->
        #handler for enter and tab key
        isEnter = evt.keyCode == 13
        isLast = $(evt.target).hasClass('last')

        if isEnter and isLast
          console.log("enter key and last item in list.  Adding new item")
          # last item in list.  Add new empty row
          scope.list.push(angular.copy(contentItemCtrl.type.listItemObj))
          submit()

        if evt.keyCode == 27 #esc key
          console.log "esc key pressed.  cancel()"
          cancel()
      )

      cancel = () ->
        console.log("reverting scope.list", scope.list)
        console.log("to", JSON.stringify(masterData))
        scope.list = angular.copy(masterData)
        submit()

      submit = () ->
        scope.finishEdit()
        scope.$apply()

      # Removes all 'empty' values (key: '', value: '') from list
      cleanList = (list) ->
        _.remove(list, (item) ->
          item.key == "" and item.value == ""
        )

      scope.finishEdit = () ->
        scope.isEditing = false
        scope.forceEdit = false
        cleanList(scope.list)

      scope.contentClicked = () ->
        scope.isEditing = true
        scope.forceEdit = true

      #Attempt to focus in on the table item once clicked in list
      scope.editListItem = (item, index, evt) ->
        #jquery nth child is 1 based
        tdIndex = if $(evt.target).hasClass('left') then 1 else 2
        $timeout(->
          tdInput = element.find("table").find("tr:nth-child(#{index + 1}) td:nth-child(#{tdIndex}) input")
          tdInput.focus().select()
        , 1)


      return
  }

])

contentModule.directive 'contentItem', ['contentTypes', '$rootScope', 'User',
  (contentTypes, $rootScope, User)->
    'ngInject'
    return {
      restrict: 'EA'
      require: 'contentItem'
      scope:
        layout: '=content'
        model: '=contentMod'
      templateUrl: "app/partials/content-item-directive.html"
      controller: ['$scope', ($scope) ->
#        console.log("contentItem.controller")

        layout = $scope.layout
        this.type = new contentTypes(layout.type)
        this.layout = layout

        console.log("contentItem.controller scope: ", $scope.model)
        if not $scope.model.data
          $scope.model.data = angular.copy(this.type.defaultValue)

        $scope.showsub = $scope.layout.subhead or false

        layout.getSubHeading = () ->
          listValues = []
          result = ""
          if $scope.showsub
            vals = $scope.model.data
            if _.isArray(vals)
              _.forEach(vals, (val) ->
                listValues = listValues.concat(val.value.split(','))
              )

              listValues = _.take(_.uniq(listValues), 3)

              result += listValues.join(', ')
          return result

        $scope.onContentElementShow = () ->
          $scope.isEditing = true

        $scope.containerClick = () ->
          $scope.isEditing = true


        this.containerClick = $scope.containerClick
        return
      ]
      link: (scope, element, attrs) ->
        layoutObj = scope.layout
        console.log("contentItem link", scope)
        if layoutObj.type == 'map'
          console.log "\n\n\n", scope.model
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


        if layoutObj.notFromUser
          scope.requireWhoSaid = true
          scope.template = "app/partials/content-item-types/.html"
          scope.saidBy = ""
          scope.model.data.fromUser = ""

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

#        if scope.layout.updateOnEvent
#          $rootScope.$on(scope.layout.updateOnEvent, (newVal, oldVal) ->
#            console.log("directive new val", [newVal, oldVal])
#            scope.model.url = typeObject.render()
#          )
    }
]

