baseUrl = "localhost:3000/"

angular.module('fileUpload', []) // using restangular is optional

.directive('uploadImage', function () {
return {
 restrict: 'A',
 link: function (scope, elem, attrs) {
  // listens on change event
  elem.on('change', function() {
    console.log('entered change function');
    scope.doc.images= []
    for (var i = 0; i < elem.length; i++) { 
      for (var x = 0; x < elem[i].files.length; x++) { 
        scope.doc.images[x]= {};
        var file = elem[i].files[x];
        // gathers file data (filename and type) to send in json 
        var imageContent = file.type;
        scope.doc.images[x]["imageContent"] = imageContent;
        var imagePath = file.name;
        scope.doc.images[x]["imagePath"] = imagePath;
       // converts file to binary string
        var reader = new FileReader();
        reader.readAsBinaryString(file);
        var y = 0
        reader.onload = function (e) {
        // retrieves the image data from the reader.readAsBinaryString method and stores as data
        // calls the uploadImage method, which does a post or put request to server
        var imageData = btoa(e.target.result);
        scope.doc.images[y]["imageData"] = imageData;
        // updates scope
        y += 1
      }
    }
    };
    scope.uploadImage(scope.doc);
    scope.$apply();
  });
 },
 // not sure where the restangular dependency is needed. This is in my code from troubleshooting scope issues before, it may not be needed in all locations. will have to reevaluate when I have time to clean up code.
 // Restangular is a nice module for handling REST transactions in angular. It is certainly optional, but it was used in my project.
 controller: ['$scope', '$location', '$resource', function($scope, $location, $resource){

  $scope.uploadImage = function (path) {
    var Doc;
    Doc = $resource('/docs/:docId', {
      docId: "@id",
      format: 'json'
    }, {
      'save': {
        method: 'PUT'
      },
      'create': {
        method: 'POST'
      }
    });
   // if updating doc
    console.log($scope.doc);
    var onError;
    onError = function(_httpResponse) {
      return flash.error = "Something went wrong";
    };

    if ($scope.doc.id) {
      $scope.doc.$save((function() {
        $scope.docImageLink = baseUrl + $scope.doc.images.image_url;
      }), onError);
    } else {
        console.log("create");
    }
   };
 }]
};
});