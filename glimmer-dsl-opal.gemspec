# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: glimmer-dsl-opal 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "glimmer-dsl-opal".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["AndyMaleh".freeze]
  s.date = "2020-06-16"
  s.description = "Glimmer DSL for Opal (Web GUI Adapter for Desktop Apps)".freeze
  s.email = "andy.am@gmail.com".freeze
  s.extra_rdoc_files = [
    "CHANGELOG.md",
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "LICENSE.txt",
    "README.md",
    "VERSION",
    "lib/glimmer-dsl-opal.rb",
    "lib/glimmer/config.rb",
    "lib/glimmer/data_binding/element_binding.rb",
    "lib/glimmer/data_binding/model_binding.rb",
    "lib/glimmer/data_binding/observable.rb",
    "lib/glimmer/data_binding/observable_array.rb",
    "lib/glimmer/data_binding/observable_model.rb",
    "lib/glimmer/data_binding/observer.rb",
    "lib/glimmer/dsl/engine.rb",
    "lib/glimmer/dsl/expression.rb",
    "lib/glimmer/dsl/expression_handler.rb",
    "lib/glimmer/dsl/opal/bind_expression.rb",
    "lib/glimmer/dsl/opal/button_expression.rb",
    "lib/glimmer/dsl/opal/combo_expression.rb",
    "lib/glimmer/dsl/opal/combo_selection_data_binding_expression.rb",
    "lib/glimmer/dsl/opal/composite_expression.rb",
    "lib/glimmer/dsl/opal/data_binding_expression.rb",
    "lib/glimmer/dsl/opal/dsl.rb",
    "lib/glimmer/dsl/opal/label_expression.rb",
    "lib/glimmer/dsl/opal/property_expression.rb",
    "lib/glimmer/dsl/opal/shell_expression.rb",
    "lib/glimmer/dsl/opal/widget_listener_expression.rb",
    "lib/glimmer/dsl/parent_expression.rb",
    "lib/glimmer/dsl/static_expression.rb",
    "lib/glimmer/dsl/top_level_expression.rb",
    "lib/glimmer/error.rb",
    "lib/glimmer/invalid_keyword_error.rb",
    "lib/glimmer/opal/div_proxy.rb",
    "lib/glimmer/opal/input_proxy.rb",
    "lib/glimmer/opal/label.rb",
    "lib/glimmer/opal/select_proxy.rb",
    "lib/glimmer/opal/shell.rb",
    "lib/samples/elaborate/contact_manager.rb",
    "lib/samples/elaborate/contact_manager/contact.rb",
    "lib/samples/elaborate/contact_manager/contact_manager_presenter.rb",
    "lib/samples/elaborate/contact_manager/contact_repository.rb",
    "lib/samples/elaborate/launch",
    "lib/samples/elaborate/login.rb",
    "lib/samples/elaborate/tic_tac_toe.rb",
    "lib/samples/elaborate/tic_tac_toe/board.rb",
    "lib/samples/elaborate/tic_tac_toe/cell.rb",
    "lib/samples/hello/hello_browser.rb",
    "lib/samples/hello/hello_combo.rb",
    "lib/samples/hello/hello_computed.rb",
    "lib/samples/hello/hello_computed/contact.rb",
    "lib/samples/hello/hello_list_multi_selection.rb",
    "lib/samples/hello/hello_list_single_selection.rb",
    "lib/samples/hello/hello_tab.rb",
    "lib/samples/hello/hello_world.rb",
    "lib/samples/hello/launch",
    "lib/samples/launch"
  ]
  s.homepage = "http://github.com/AndyObtiva/glimmer-dsl-opal".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Glimmer DSL for Opal".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<glimmer>.freeze, ["~> 0.9.1"])
    s.add_development_dependency(%q<rspec-mocks>.freeze, ["~> 3.5.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_development_dependency(%q<puts_debuggerer>.freeze, ["~> 0.8.1"])
    s.add_development_dependency(%q<rake>.freeze, [">= 10.1.0", "< 14.0.0"])
    s.add_development_dependency(%q<jeweler>.freeze, [">= 2.3.9", "< 3.0.0"])
    s.add_development_dependency(%q<rdoc>.freeze, [">= 6.2.1", "< 7.0.0"])
    s.add_development_dependency(%q<opal-rspec>.freeze, ["~> 0.7.1"])
    s.add_development_dependency(%q<opal-browser>.freeze, ["~> 0.2.0"])
  else
    s.add_dependency(%q<glimmer>.freeze, ["~> 0.9.1"])
    s.add_dependency(%q<rspec-mocks>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<puts_debuggerer>.freeze, ["~> 0.8.1"])
    s.add_dependency(%q<rake>.freeze, [">= 10.1.0", "< 14.0.0"])
    s.add_dependency(%q<jeweler>.freeze, [">= 2.3.9", "< 3.0.0"])
    s.add_dependency(%q<rdoc>.freeze, [">= 6.2.1", "< 7.0.0"])
    s.add_dependency(%q<opal-rspec>.freeze, ["~> 0.7.1"])
    s.add_dependency(%q<opal-browser>.freeze, ["~> 0.2.0"])
  end
end

