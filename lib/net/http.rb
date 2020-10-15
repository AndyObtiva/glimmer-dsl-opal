# Missing Net module class methods TODO implement

require_relative '../uri'

module Net
  # TODO Implement HTTP with jQuery for use in Glimmer DSL for Opal
  # Note: ignore Protocol superclass for now
  class HTTP
    def post_form(uri, params)
#       pd uri.scheme
#       pd uri.host
#       pd uri.path
#       pd uri.query
#       pd params
    end
  end
end
