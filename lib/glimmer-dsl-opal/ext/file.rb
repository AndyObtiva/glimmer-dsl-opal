# Copyright (c) 2020-2021 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class File
  class << self
    REGEXP_DIR_FILE = /\(dir\)|\(file\)/
  
    def read(*args, &block)
      # TODO implement via asset downloads in the future
      # No Op in Opal
    end
    
    # Include special processing for images that matches them against a list of available image paths from the server
    # to convert to web paths.
    alias expand_path_without_glimmer expand_path
    def expand_path(path, base=nil)
      if base
        path = expand_path_without_glimmer(path, base)
      end
      path_include_dir_or_file = !!path.match(REGEXP_DIR_FILE)
      if !path_include_dir_or_file
        path
      else
        essential_path = path.split('(dir)').last.split('(file)').last
        image_paths.detect do |image_path|
          image_path.include?(essential_path)
        end
      end
    end
    
    def image_paths
      # TODO call to server with ajax hitting /glimmer/image_paths.json
      ['/assets/glimmer/hello_table/baseball_park.png']
    end
    
  end
end
