module Glimmer
  class ImagePathsController < ApplicationController
    def index
      # TODO derive image paths by convention (or full directory scanning) from glimmer-dsl-opal and all gems that depend on it
#       Gem.loaded_specs.values.map(&:dependencies)
      #.map(&:name).include?('glimmer-dsl-opal') # broken
      image_paths = ['/assets/glimmer/hello_table/baseball_park.png']
      render json: image_paths
    end
  
  end
end
