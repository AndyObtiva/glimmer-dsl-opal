require 'fileutils'

module Glimmer
  class ImagePathsController < ApplicationController
    def index
      # TODO apply caching in the future to avoid recopying files on every request
      Gem.loaded_specs.map(&:last).select {|s| s.name == 'glimmer-dsl-opal' || s.dependencies.detect {|dep| dep.name == 'glimmer-dsl-opal'} }
      full_gem_specs = Gem.loaded_specs.map(&:last).select do |s|
        s.name == 'glimmer-dsl-opal' ||
          Glimmer::Config.gems_having_image_paths.to_a.include?(s.name) || # consider turning into a Glimmer::Config server-side option
          s.dependencies.detect {|dep| dep.name == 'glimmer-dsl-swt'}
      end
      full_gem_paths = full_gem_specs.map {|gem_spec| gem_spec.full_gem_path}
      full_gem_names = full_gem_paths.map {|path| File.basename(path)}
      full_gem_image_path_collections = full_gem_paths.map do |gem_path|
        Dir[File.join(gem_path, '**', '*')].to_a.select {|f| !!f.match(/(png|jpg|jpeg|gif)$/) }
      end
      download_gem_image_path_collections = full_gem_names.size.times.map do |n|
        full_gem_name = full_gem_names[n]
        full_gem_image_paths = full_gem_image_path_collections[n]
        full_gem_image_paths.map do |image_path|
          File.join(full_gem_name, image_path.split(full_gem_name).last)
        end
      end
      download_gem_image_paths = download_gem_image_path_collections.flatten
      download_gem_image_dir_names = download_gem_image_paths.map {|p| File.dirname(p)}.uniq
      download_gem_image_dir_names.each do |image_dir_name|
        FileUtils.mkdir_p(Rails.root.join('app', 'assets', 'images', image_dir_name))
      end
      full_gem_names.size.times.each do |n|
        full_image_paths = full_gem_image_path_collections[n]
        download_image_paths = download_gem_image_path_collections[n]
        full_image_paths.each_with_index do |image_path, i|
          download_image_path = download_image_paths[i]
          image_dir_name = File.dirname(image_path)
          FileUtils.cp_r(image_path, Rails.root.join('app', 'assets', 'images', download_image_path)) # TODO check first if files match and avoid copying if so to save time
        end
      end
      download_gem_image_paths = download_gem_image_paths.map {|p| "/assets/#{p}"}
            
      # TODO apply a security white list
      render json: download_gem_image_paths
    end
  
  end
end
