contentModule = angular.module 'content', []

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


    $scope.mySections = []

])
contentModule.factory 'contentTypes', () ->
  types = {

  }

  return types

contentModule.directive 'contentItem', () ->
  'ngInject'
  return {
    restrict: 'E'
    scope:
      model: '=content'
    templateUrl: 'app/partials/content-item-directive.html'
    link: (scope, element, attrs) ->
      console.log("Scope.content", scope.model)

      scope.bodyClick = ->
        console.log("clicked", scope.model.name)
  }

