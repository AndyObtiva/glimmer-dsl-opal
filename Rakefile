require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
begin
  jeweler_required = require 'jeweler'
rescue Exception
  jeweler_required = nil
end
unless jeweler_required.nil?
  Jeweler::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
    gem.name = "glimmer-dsl-opal"
    gem.homepage = "http://github.com/AndyObtiva/glimmer-dsl-opal"
    gem.license = "MIT"
    gem.summary = %Q{Glimmer DSL for Opal}
    gem.description = %Q{Glimmer DSL for Opal (Web GUI Adapter for Desktop Apps)}
    gem.email = "andy.am@gmail.com"
    gem.authors = ["AndyMaleh"]
    gem.executables = []
    gem.files = Dir['README.md', 'LICENSE.txt', 'VERSION', 'lib/**/*', 'samples/**/*', 'css/**/*']
    # dependencies defined in Gemfile
  end
  Jeweler::RubygemsDotOrgTasks.new
end

#require 'opal/rspec/rake_task'
#Opal::RSpec::RakeTask.new(:default) do |server, task|
#  server.append_path File.expand_path('../lib', __FILE__)
#  require 'opal-async'
#  Opal.use_gem('glimmer-dsl-opal')
#end

task :no_puts_debuggerer do
  ENV['puts_debuggerer'] = 'false'
end

namespace :build do
  desc 'Builds without running specs for quick testing, but not release'
  task :prototype => :no_puts_debuggerer do
    Rake::Task['build'].execute
  end
end

# Rake::Task["build"].enhance [:no_puts_debuggerer, :spec] #TODO enable once opal specs are running
task :default do
  puts "To run opal specs, visit: http://localhost:9292 "
  system `rackup`
end
