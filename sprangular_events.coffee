angular.module('Sprangular.Events', ['Sprangular'])

angular.module('Sprangular.Events').config ($injector, $provide, NotificationProvider) ->
  return unless $injector.has 'Newsletter'

  $provide.decorator 'Newsletter', ($delegate) ->
    implementation = $delegate.subscribe

    $delegate.subscribe = (email) ->
      implementation.call($delegate, email).then ->
        NotificationProvider.fire 'newsletter.subscribe', email: email

    $delegate

angular.module('Sprangular.Events').config ($injector, $provide, NotificationProvider) ->
  return unless $injector.has 'Checkout'

  $provide.decorator 'Checkout', ($delegate) ->
    implementation = $delegate.complete

    $delegate.complete = ->
      implementation.call($delegate).then (order) ->
        NotificationProvider.fire 'checkout.complete', order: order

        order

    $delegate

angular.module('Sprangular.Events').run ($rootScope, $location, Notification) ->
  $rootScope.$on '$routeChangeSuccess', (event, data) ->
    Notification.fire "page.view", location: $location

angular.module('Sprangular.Events').provider 'Notification', ->
  NotificationChannel =
    fire: (name, data) ->
      @channel?.$broadcast name, data

    register: (name, handler) ->
      @channel?.$on name, (event, data) ->
        handler event, data

    $get: ($rootScope) ->
      NotificationChannel.channel = $rootScope.$new true
      NotificationChannel

  NotificationChannel
