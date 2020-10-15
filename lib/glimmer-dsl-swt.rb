class OS
  class << self
    def windows?
      # No Op in Opal
    end
    
    def mac?
      # No Op in Opal
    end
    
    def linux?
      # No Op in Opal
    end
  end
end

class File
  class << self
    def read(*args, &block)
      # No Op in Opal
    end
  end
end

class Display
  class << self
    def setAppName(app_name)
      # No Op in Opal
    end
    def setAppVersion(version)
      # No Op in Opal
    end
  end
end

require 'glimmer-dsl-opal'
