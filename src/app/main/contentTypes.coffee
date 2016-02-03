class ContentType
  constructor: (@type="text", @content="") ->

  setContent: (content) ->
    @content = content

  loadContent: () ->
    return @content

class MapContentType extends ContentType
  constructor: (@type, @content) ->
    super("map", @content)

  loadContent: () ->


class FileContentType extends ContentType
  constructor: () ->
    super("file")

