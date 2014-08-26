controllers = angular.module('controllers')
controllers.controller("DocsController", [ '$scope', '$routeParams', '$location', '$resource', '$http',
  ($scope,$routeParams,$location,$resource, $http)->
    $scope.search = (keywords)->  $location.path("/").search('keywords',keywords)
    Docs = $resource('/docs/:docId', { docId: "@id", format: 'json' })
    
    if $routeParams.keywords
      Docs.query(keywords: $routeParams.keywords, (results)-> $scope.docs = results)
      console.log("true")
    else
      $scope.docs = []

    $scope.view = (docId)-> $location.path("/docs/#{docId}")
    $scope.newDocs = -> $location.path("/docs/new")
    $scope.edit      = (docId)-> $location.path("/docs/#{docId}/edit")
])