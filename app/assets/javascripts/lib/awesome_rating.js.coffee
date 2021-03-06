roundSimpleRating = (rating) ->
  if Ember.isNone(rating)
    return null

  if rating > 2.4 and rating < 3.6
    return 3
  else if rating < 3
    return 1
  else
    return 5

simpleRatingIcons =
  1: 'fa fa-frown-o'
  3: 'fa fa-meh-o'
  5: 'fa fa-smile-o'

advancedRatingIcons = ['fa fa-star-o', 'fa fa-star-half-o', 'fa fa-star']

nearestHalf = (number) ->
  if Ember.isNone(number)
    return null
  return Math.floor(number*2) / 2

starFor = (rating, i) ->
  if nearestHalf(rating) - i > -0.01
    return advancedRatingIcons[2]
  else if nearestHalf(rating) - i > -0.51
    return advancedRatingIcons[1]
  else
    return advancedRatingIcons[0]

renderStars = (rating) ->
  stars = ""
  for i in [1..5]
    stars += "<span class='icon-container' data-rating='" + i + "'><i class='" + starFor(rating, i) + "'></i></span>"
  stars

$.fn.AwesomeRating = (options) ->
  @each ->
    widget = this
    rating = options["rating"]
    $(widget).empty()
    $(widget).unbind()
    if options["editable"]
      $(widget).addClass "editable"
    if options["type"] == "simple"
      # Simple ratings.
      rating = roundSimpleRating rating
      for i in [1, 3, 5]
        icon = $("<span class='icon-container' data-rating='" + i + "'><i></i></span>")
        icon.find("i").addClass simpleRatingIcons[i]
        if rating == i
          icon.find("i").addClass "active"
        if options["editable"]
          icon.css 'cursor', 'pointer'
          icon.click ->
            newRating = roundSimpleRating($(this).attr("data-rating"))
            options["update"](newRating)
        $(this).append icon
    else
      # Advanced ratings.
      rating = nearestHalf rating
      $(widget).html renderStars rating
      if options["editable"]
        $(widget).css 'cursor', 'pointer'
        $(widget).bind
          mousemove: (e) ->
            newRating = nearestHalf(5 * (e.pageX - $(widget).offset().left) / $(widget).width() + 0.5)
            $(widget).find(".icon-container").each ->
              index = $(this).attr("data-rating")
              starClass = starFor newRating, index
              $(this).find("i").removeClass('fa-star').removeClass('fa-star-half-o').removeClass('fa-star-o').addClass starClass
          mouseleave: ->
            $(widget).html renderStars rating
          click: (e) ->
            newRating = nearestHalf(5 * (e.pageX - $(widget).offset().left) / $(widget).width() + 0.5)
            options["update"](newRating)

