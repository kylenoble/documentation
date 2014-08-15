documentation = angular.module('documentation',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
])

documentation.config([ '$routeProvider','flashProvider', '$locationProvider' 
  ($routeProvider, flashProvider, $locationProvider)->

    flashProvider.errorClassnames.push("alert-danger")
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")


    $routeProvider
      .when('/',
         templateUrl: "index.html"
         controller: 'ItemCtrl'
      ).when('/docs/new',
        templateUrl: "form.html"
        controller: 'DocController'
       ).when('/docs/:docId',
         templateUrl: "show.html"
         controller: 'DocController'
      ).when('/docs/:docId/edit',
        templateUrl: "form.html"
        controller: 'DocController'
       )

    $locationProvider.html5Mode(true).hashPrefix('!')
])

controllers = angular.module('controllers',[])
