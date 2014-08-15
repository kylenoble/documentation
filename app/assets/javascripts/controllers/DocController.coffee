controllers = angular.module('controllers')
controllers.controller("DocController", [ '$scope', '$routeParams', '$resource', '$location', 'flash',
  ($scope,$routeParams,$resource,$location, flash)->
    Doc = $resource('/docs/:docId', { docId: "@id", format: 'json' },
      {
        'save':   {method:'PUT'},
        'create': {method:'POST'}
      }
    )

    console.log($routeParams.docId)
    console.log("test")

    if $routeParams.docId
      Doc.get({docId: $routeParams.docId},
        ( (doc)-> $scope.doc = doc ),
        ( (httpResponse)->
          $scope.doc = null
          flash.error   = "There is no doc with ID #{$routeParams.docId}"
        )
      )
    else
      $scope.doc = {}

    $scope.back   = -> $location.path("/")
    $scope.edit   = -> $location.path("/docs/#{$scope.doc.id}/edit")
    $scope.cancel = ->
      if $scope.doc.id
        $location.path("/docs/#{$scope.doc.id}")
      else
        $location.path("/")

    $scope.save = ->
      onError = (_httpResponse)-> flash.error = "Something went wrong"
      if $scope.doc.id
        $scope.doc.$save(
          ( ()-> $location.path("/docs/#{$scope.doc.id}") ),
          onError)
      else
        Doc.create($scope.doc,
          ( (newdoc)-> $location.path("/docs/#{newdoc.id}") ),
          onError
        )

    $scope.delete = ->
      $scope.doc.$delete()
      $scope.back()
])