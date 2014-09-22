controllers = angular.module('controllers')
controllers.controller("ItemCtrl", [ '$scope', '$routeParams', '$location', '$resource', '$http', '$sce', '$window',
  ($scope,$routeParams,$location,$resource, $http, $sce, $window)->
    $scope.item = []
    $http.get('/data/index.json').success((data)->
      $scope.item = (data) 
    )

    $scope.token = $window.token

    $scope.item.info = $sce.trustAsHtml($scope.item.info)

    idNum = $scope.item.id

    $scope.view = (idNum)-> $location.path("/docs/#{idNum}")
    $scope.newDoc = -> $location.path("/docs/new")
    $scope.edit      = (idNum)-> $location.path("/docs/#{idNum}/edit")
    $scope.cancel = ->
      if $scope.doc.id
        $location.path("/docs/#{$scope.doc.id}")
      else
        $location.path("/")

])


