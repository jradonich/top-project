angular.module 'toptalProject'
  .run ($log, editableOptions, editableThemes) ->
    'ngInject'
    editableOptions.theme = 'bs3'
    editableThemes.bs3.inputClass = 'input-sm'
    editableThemes.bs3.buttonsClass = 'btn-sm'
    $log.debug 'runBlock end'

