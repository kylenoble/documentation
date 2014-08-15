controllers = angular.module('controllers')
controllers.controller("ItemCtrl", [ '$scope', '$routeParams', '$location', '$resource', '$http',
  ($scope,$routeParams,$location,$resource, $http)->
    $scope.item = []
    $http.get('/data/index.json').success((data)->
      $scope.item = (data)
    )

    idNum = $scope.item.id

    $scope.view = (idNum)-> $location.path("/recipes/#{idNum}")
    $scope.newRecipe = -> $location.path("/recipes/new")
    $scope.edit      = (idNum)-> $location.path("/recipes/#{idNum}/edit")
    $scope.cancel = ->
      if $scope.recipe.id
        $location.path("/recipes/#{$scope.recipe.id}")
      else
        $location.path("/")

])