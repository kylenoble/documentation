controllers = angular.module('controllers')
controllers.controller("DocController", [ '$scope', '$routeParams', '$resource', '$location', 'flash', '$sce', '$upload', 'Restangular', '$window'
  ($scope,$routeParams,$resource,$location, flash, $sce, $upload, Restangular, $window)->
    Doc = $resource('/docs/:docId', { docId: "@id", format: 'json' },
      {
        'save':   {method:'PUT'},
        'create': {method:'POST'}
      }
    )

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


    console.log($scope.doc)

    $scope.renderHtml = (html_code) ->
      return $sce.trustAsHtml(html_code)

    $scope.newDocs = -> $location.path("/docs/:docId/new")  
    $scope.back   = -> $location.path("/")
    $scope.edit   = -> $location.path("/docs/#{$scope.doc.id}/edit")
    $scope.cancel = ->
      if $scope.doc.id
        if $scope.doc.parent == '' && $scope.doc.info == '' && $scope.doc.title == ''
          $scope.doc.$delete()
          $location.path("/")
        else
          $location.path("/docs/#{$scope.doc.id}")
      else
        $location.path("/")

    $scope.delete = ->
        $scope.doc.$delete()
        $scope.back()

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

    $scope.onFileSelect = ($files, additionalCallback) ->
      additionalCallback = () ->
        if $scope.needToRedirect
          $window.location.replace "/docs"
          return
        if $scope.needToReload
          $window.location.replace "/docs/" + response.id + "/edit"
          return

      if angular.isUndefined($scope.doc.id)
        $scope.filesToUpload = $files
        Doc.create $scope.doc.id, true  if $scope.canBeCreated
        return
      
      #$files: an array of files selected, each file has name, size, and type.
      i = 0

      while i < $files.length
        file = $files[i]
        $scope.upload = $upload.upload(
          url: "/docs/" + $scope.doc.id + "/images"
          file: file
        ).progress((evt) ->
          console.log "percent: " + parseInt(100.0 * evt.loaded / evt.total)
        ).success((data, status, headers, config) ->
          
          # file is uploaded successfully
          $scope.doc.images.push data
          $scope.filesToUpload = _.without($scope.filesToUpload, file)  if angular.isDefined($scope.filesToUpload)
          additionalCallback()
        )
        i++

    $scope.$watch "docForm.$valid", (newVal) ->
      return  if angular.isUndefined(newVal)
      return  unless newVal
      return  if angular.isDefined($routeParams.id)

      $scope.canBeCreated = true

    allClear = (response) ->
      $scope.doc = response
      $scope.doc.images = _.object(_.map(response.images, (images) ->
        [ images.image, true ]
      ))
      unless $scope.fileTagStyle is true
        $("input[type=file]").bootstrapFileInput()
        $scope.fileTagStyle = true
      additionalCallback = () ->
        if $scope.needToRedirect
          $window.location.replace "/docs"
          return
        if $scope.needToReload
          $window.location.replace "/docs/" + response.id + "/edit"
          return

      if angular.isDefined($scope.filesToUpload) and $scope.filesToUpload.length > 0
        $scope.onFileSelect $scope.filesToUpload, additionalCallback
      else
        additionalCallback()

    if $routeParams.docId > 0
      console.log("working")
    else
      onError = (_httpResponse)-> flash.error = "Something went wrong"
      Doc.create({"title":"", "parent":"", "info":""},
          ( (newdoc)-> $location.path("/docs/#{newdoc.id}/edit") ),
          onError
        )
])

