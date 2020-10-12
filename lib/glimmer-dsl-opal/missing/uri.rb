# Missing URI module class features

module URI
  class HTTP
    REGEX = /([^:]+):\/\/([^\/])\/([^?]*)\??(.*)/
    
    def initialize(url)
      @url = url
      uri_match = url.match(REGEX)
      @scheme = uri_match[1]
      @host = uri_match[2]
      @path = uri_match[3]
      @query = uri_match[4]
      # TODO fragment
    end
    
    def to_s
      url
    end
  end
end
module Kernel
  def URI(url)
    URI::HTTP.new(url)
  end
end
