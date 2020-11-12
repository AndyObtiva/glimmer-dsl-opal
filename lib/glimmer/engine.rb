module Glimmer
  class Engine < ::Rails::Engine
    isolate_namespace Glimmer

    initializer "glimmer.assets.precompile" do |app|
      app.config.assets.precompile += %w( glimmer.css jquery-ui.css jquery-ui.structure.css jquery-ui.theme.css jquery.ui.timepicker.css )
    end
  end
end
