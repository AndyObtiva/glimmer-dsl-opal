module Glimmer
  class Engine < ::Rails::Engine
    isolate_namespace Glimmer

    initializer "glimmer.assets.precompile" do |app|
      app.config.assets.precompile += %w( glimmer/glimmer.css )
    end
  end
end
