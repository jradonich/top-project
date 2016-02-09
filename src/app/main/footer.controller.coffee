footer = angular.module('footer', [])

footer.controller('FooterController', ['$scope', ($scope) ->
  'ngInject'
  $scope.topSkillsList = [
    ['.NET Programmers', '3ds Max Engineers'],
    [
      'Administrative Assistants'
      'Advertising Consultants'
      'AJAX Programmers'
      'Amazon Web Services'
      'Android Programmers'
      'Animators'
      'Article Writers'
      'ASP Programmers'
      'ASP.NET Programmers'
    ]
    ['Blog Writers', 'Business Writers']
    [
      'C Programmers'
      'Cocoa Programmers'
      'Content Writers'
      'Copyright Attorneys'
      'Creative Writer'
      'CSS Programmers'
      'Customer Service Reps'
    ]
    [
      'Data Entry Experts'
      'DHTML Programmers'
      'Dot Net Nuke Programmers'
      'Drupal Programmers'
    ]
    [
      'Flash Designers'
      'Foursquare Programmers'
      'French Translators'
    ]
    ['Google App Engineer', 'Graphic Designers']
    ['HTML Programmers', 'HTML5 Programmers']
    ['Illustrator Designers', 'InDesign Designers', 'iPhone Programmers']
    ['Java Programmers', 'JavaScript Programmers', 'Joomla Programmers']
    ['LAMP Programmers', 'Linux Programmers', 'Logo Designers']
    [
      'Mac OS Programmers'
      'Magento Programmers'
      'Microsoft Excel Experts'
      'Microsoft Sharepoint'
      'Mobile Programmers'
      'MySQL Programmers'
    ]
    ['Newsletter Writers']
    ['Office Administrators', 'Online Writers', 'Oracle Programmers', 'osCommerce Programmers']
    ['Palm Programmers', 'PayPal Programmers', 'Photoshop Designers', 'PHP Programmers']
    ['Ruby on Rails Progammers']
    [
      'Salesforce.com Programmers'
      'SAP Programmers'
      'SEM Consultants'
      'SEO Consultants'
      'Software Testing Programmers'
      'Spanish Translators'
      'SQL Programmers'
    ]
    ['Transcriptionists']
  ]
  $scope.topSkills = {
    '.': ['.NET Programmers', '3ds Max Engineers'],
    'A': [
      'Administrative Assistants'
      'Advertising Consultants'
      'AJAX Programmers'
      'Amazon Web Services'
      'Android Programmers'
      'Animators'
      'Article Writers'
      'ASP Programmers'
      'ASP.NET Programmers'
    ]
    'B': ['Blog Writers', 'Business Writers']
    'C': [
      'C Programmers'
      'Cocoa Programmers'
      'Content Writers'
      'Copyright Attorneys'
      'Creative Writer'
      'CSS Programmers'
      'Customer Service Reps'
    ]
    'D': [
      'Data Entry Experts'
      'DHTML Programmers'
      'Dot Net Nuke Programmers'
      'Drupal Programmers'
    ]
    'F': [
      'Flash Designers'
      'Foursquare Programmers'
      'French Translators'
    ]
    'G': ['Google App Engineer', 'Graphic Designers']
    'H': ['HTML Programmers', 'HTML5 Programmers']
    'I': ['Illustrator Designers', 'InDesign Designers', 'iPhone Programmers']
    'J': ['Java Programmers', 'JavaScript Programmers', 'Joomla Programmers']
    'L': ['LAMP Programmers', 'Linux Programmers', 'Logo Designers']
    'M': [
      'Mac OS Programmers'
      'Magento Programmers'
      'Microsoft Excel Experts'
      'Microsoft Sharepoint'
      'Mobile Programmers'
      'MySQL Programmers'
    ]
    'N': ['Newsletter Writers']
    'O': ['Office Administrators', 'Online Writers', 'Oracle Programmers', 'osCommerce Programmers']
    'P': ['Palm Programmers', 'PayPal Programmers', 'Photoshop Designers', 'PHP Programmers']
    'R': ['Ruby on Rails Progammers']
    'S': [
      'Salesforce.com Programmers'
      'SAP Programmers'
      'SEM Consultants'
      'SEO Consultants'
      'Software Testing Programmers'
      'Spanish Translators'
      'SQL Programmers'
    ]
    'T': ['Transcriptionists']
  }
])
