# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
app = angular.module('messageApp', ['ngResource'])

app.factory 'Message',
  ($resource) ->
    $resource('/api/messages/:id', id: '@id')
    
app.factory 'Auth',
  ($http) ->
    login: (inputs, options = {}) ->
      $http.post("/api/users/sign_in", inputs).success(options.success || (() -> ))
    logout: () ->
      $http.delete("/api/users/sign_out")

    
app.config ["$httpProvider", ($httpProvider) ->
  # Inject the CSRF token
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = document.getElementsByName("csrf-token")[0].content
  # By default, angular sends "application/json, text/plain, */*" which rails
  # sees and focuses on the */* and sends html :-(
  $httpProvider.defaults.headers.common['Accept'] = "application/json"
  
  $httpProvider.responseInterceptors.push(['$rootScope', '$q',
    (scope, $q) ->
      
      success = (response) ->
        scope.$broadcast('loggedIn')
        response
      
      error = (response) ->
        status = response.status
        
        if status == 401 || status == 422
          deferred = $q.defer()
          
          scope.$broadcast('loginRequired')
          return deferred.promise
        
        scope.$broadcast('loggedIn')
        $q.reject(response)  
      
      (promise) ->
        promise.then(success, error)
  ])
]

app.controller 'MessageCtrl',
  ($scope, Message, Auth) ->     
    $scope.message = { body: "", sender_name: "" }
    $scope.user = { username: "", password: "" }
    # index
    $scope.messages = Message.query()
    
    # create
    $scope.sendMessage = () ->
      Message.save(
        { sender_name: 'user' , body: $scope.message.body }
      , (response) ->
          $scope.messages.push response
          $scope.message.body = ""
      )
    
    # destroy    
    $scope.deleteMessage = (idx) ->
      if confirm("Are you sure you want to delete this post?")
        $scope.messages[idx].$remove(() ->
          $scope.messages.splice(idx, 1)
        )
    
    # login
    $scope.login = () ->
      login_params = { user_login: { username: $scope.user.username, password: $scope.user.password}}
      
      success_cb = (response) ->
        $scope.current_user = { username: response.username }
        $scope.user = { username: "", password: "" }
        alert("You have logged in")
          
      options = { success: success_cb }
      Auth.login login_params, options
    
    # logout
    $scope.logout = () ->
      Auth.logout()
    
    $scope.$on('loginRequired', (event, e) ->
      $scope.logged_in = false
    )
    
    $scope.$on('loggedIn', (event, e) ->
      if $scope.logged_in == false
        $scope.messages = Message.query()
      $scope.logged_in = true
    )
    true
    