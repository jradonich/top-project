angular.module 'toptalProject'
  .run ($log, editableOptions) ->
    'ngInject'
    editableOptions.theme = 'bs3'
    $log.debug 'runBlock end'

