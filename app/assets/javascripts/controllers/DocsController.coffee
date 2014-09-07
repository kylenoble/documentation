controllers = angular.module('controllers')
controllers.controller("DocsController", [ '$scope', '$routeParams', '$location', '$resource', '$http', '$upload'
  ($scope,$routeParams,$location,$resource, $http, $upload)->
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

    $scope.onFileSelect = ($files) ->
      #$files: an array of files selected, each file has name, size, and type.
      i = 0

      while i < $files.length
        file = $files[i]
        $scope.upload = $upload.upload(
          url: "/docs"
          file: file
        ).progress((evt) ->
          console.log "percent: " + parseInt(100.0 * evt.loaded / evt.total)
          return
        ).success((data, status, headers, config) ->
          
          # file is uploaded successfully
          # $scope.task.pictures.push data
          return
        )
        i++
      return
])