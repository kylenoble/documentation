var baseUrl = 'http localhost:port'; // fill in as needed

angular.module('fileUpload', []) // using restangular is optional

.directive('uploadImage', function () {
return {
 restrict: 'A',
 link: function (scope, elem, attrs) {
  var reader = new FileReader();
  reader.onload = function (e) {
    // retrieves the image data from the reader.readAsBinaryString method and stores as data
    // calls the uploadImage method, which does a post or put request to server
    scope.doc.imageData = btoa(e.target.result);
    scope.uploadImage(scope.doc.imagePath);
    // updates scope
    scope.$apply();
  };

  // listens on change event
  elem.on('change', function() {
    console.log('entered change function');
    var file = elem[0].files[0];
    // gathers file data (filename and type) to send in json
    scope.doc.imageContent = file.type;
    scope.doc.imagePath = file.name;
    // updates scope; not sure if this is needed here, I can not remember with the testing I did...and I do not quite understand the apply method that well, as I have read limited documentation on it.
    scope.$apply();
    // converts file to binary string
    reader.readAsBinaryString(file);
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
        $scope.docImageLink = baseUrl + $scope.doc.image_url;
      }), onError);
    } else {
        console.log("create");
    }
   };
 }]
};
});