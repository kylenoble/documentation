controllers = angular.module('controllers')
controllers.controller("DocController", [ '$scope', '$routeParams', '$resource', '$location', 'flash', '$sce', '$upload'
  ($scope,$routeParams,$resource,$location, flash, $sce, $upload, Restangular)->
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

    $scope.renderHtml = (html_code) ->
      return $sce.trustAsHtml(html_code)

    $scope.openFileWindow = () ->
      angular.element( document.querySelector( '#fileUpload' ) ).trigger('click')
      console.log('triggering click')

    $scope.newDocs = -> $location.path("/docs/:docId/new")  
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

    $scope.onFileSelect = ($files, additionalCallback) ->
      if angular.isUndefined($scope.doc)
        $scope.filesToUpload = $files
        $scope.newDoc($scope.doc, true)  if $scope.canBeCreated
        return
      
      #$files: an array of files selected, each file has name, size, and type.
      i = 0

      while i < $files.length
        file = $files[i]
        $scope.upload = $upload.upload(
          url: '/docs/' + $scope.doc.id + '/images'  
          file: file
        ).progress((evt) ->
          console.log "percent: " + parseInt(100.0 * evt.loaded / evt.total)
          return
        ).success((data, status, headers, config) ->
          
          # file is uploaded successfully
          $scope.doc.images.push data
          $scope.filesToUpload = _.without($scope.filesToUpload, file)  if angular.isDefined($scope.filesToUpload)
          #additionalCallback()
          return
        )
        i++
      return

    $scope.$watch "Form.$valid", (newVal) ->
      return  if angular.isUndefined(newVal)
      return  unless newVal
      return  if angular.isDefined($scope.doc.id)
      $scope.canBeCreated = true
      return

    allClear = (response) ->
      $scope.doc = response
      console.log(response)
      unless $scope.fileTagStyle is true
        $("input[type=file]").bootstrapFileInput()
        $scope.fileTagStyle = true
      additionalCallback = additionalCallback () ->
        if $scope.needToRedirect
          $window.location.replace "/docs/" + $response.id + '/images'
          return
        if $scope.needToReload
          $window.location.replace "/docs/" + response.id + "/edit"
          return

      if angular.isDefined($scope.filesToUpload) and $scope.filesToUpload.length > 0
        $scope.onFileSelect $scope.filesToUpload, additionalCallback
      else
        additionalCallback()
      return

      if angular.isNumber($scope.product.id)
        Restangular.one("docs", $scope.doc.id).patch(fields).then allClear, (error) ->
          $scope.errors = error.data
          return
      else
        Restangular.all("docs").post(fields).then allClear, (error) ->
          $scope.errors = error.data
          return

])

