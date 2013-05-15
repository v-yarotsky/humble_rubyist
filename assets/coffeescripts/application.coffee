class window.Post extends Backbone.Model
  urlRoot: "api/posts"

  defaults:
    id:            null,
    title:         "",
    slug:          "",
    published_at:  "",
    content:       "",
    icon:          ""

class window.PostsCollection extends Backbone.Collection
  model: Post
  url: "api/posts"
  parse: (resp, xhr) ->
    resp.posts

class window.PostListItemView extends Backbone.View
  tagName: "li"

  initialize: ->
    @model.bind("change", @render, @)
    @model.bind("destroy", @render, @)

  render: ->
    $(@el).html(@template(@model.toJSON()))
    @

class window.PostsListView extends Backbone.View
  initialize: ->
    @render()

  render: ->
    posts = @collection.models
    $(@el).html("<ul class=\"posts\"></ul>")
    $(".posts", @el).append(new PostListItemView(model: post).render().el) for post in posts
    @

class window.PostView extends Backbone.View
  events:
    "change":         "change"
    "click .save":    "save_post"
    "click .delete":  "delete_post"

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(@model.toJSON()))

  change: (event) ->
    target = event.target
    change = {}
    change[target.name] = target.value
    @model.set(change)

  save_post: ->
    @model.save null,
      success: (model) ->
        @render
        app.navigate("posts/" + model.id, false)
      error: ->
        alert("Error saving post")

  delete_post: ->
    @model.destroy
      success: ->
        alert("Post deleted")
        window.history.back()

class window.AppRouter extends Backbone.Router
  routes:
    "":           "listPosts",
    "posts/add":  "addPost",
    "posts/:id":  "editPost"

  listPosts: ->
    posts = new PostsCollection
    posts.fetch
      success: ->
        $("#content").html(new PostsListView(collection: posts).el)

  editPost: (id) ->
    post = new Post(id: id)
    post.fetch
      success: ->
        $("#content").html(new PostView(model: post).el)

Template =
  load: (views) ->
    window[view].prototype.template = _.template($("script." + view + "Template").html()) for view in views

$ ->
  Template.load(["PostListItemView", "PostView"])
  window.app = new AppRouter
  Backbone.history.start()

