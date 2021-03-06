Hummingbird.ApplicationRoute = Ember.Route.extend
  setupController: (controller, model) ->
    headerController = @controllerFor("header")
    headerController.set("notifications", @store.find('notification'))



  actions:
    setupQuickUpdate: ->
      headerController = @controllerFor("header")
      if @get('currentUser.isSignedIn')
        headerController.set 'recentLibraryEntries', @store.find('library_entry', {user_id: @get('currentUser.id'), recent: true})
      else 
        headerController.set 'recentLibraryEntries', []
    toggleFollow: (user) ->
      unless @get('currentUser.isSignedIn')
        alert "Need to be signed in!"
        return
      originalState = user.get('isFollowed')
      user.set 'isFollowed', !originalState
      ic.ajax
        url: "/users/" + user.get('id') + "/follow"
        type: "POST"
        dataType: "json"
      .then Ember.K, ->
        alert "Something went wrong."
        user.set 'isFollowed', originalState

    openModal: (modalName, model) ->
      @controllerFor("modals." + modalName).set 'content', model
      @render "modals/" + modalName,
        outlet: 'modal'
        into: 'application'

    closeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'
