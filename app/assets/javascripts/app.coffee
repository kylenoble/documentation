documentation = angular.module('documentation',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'restangular',
  'angular-flash.service',
  'angular-flash.flash-alert-directive',
  'angular-loading-bar',
  'angularFileUpload'
])

documentation.config([ '$routeProvider','flashProvider', '$locationProvider', '$provide' 
  ($routeProvider, flashProvider, $locationProvider, $provide)->

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
       ).when('/docs/:docId/new',
        templateUrl: "form.html"
        controller: 'DocController'
      )

    $locationProvider
      .html5Mode(false)
      .hashPrefix('!')
])

controllers = angular.module('controllers',[])

