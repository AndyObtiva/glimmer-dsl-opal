require 'net/http'
require 'json'
require 'facets/string/titlecase'

class Weather
  include Glimmer::UI::CustomShell
  
  DEFAULT_FONT_HEIGHT = 30
  DEFAULT_FOREGROUND = :white
  DEFAULT_BACKGROUND = rgb(135, 176, 235)
  
  attr_accessor :city, :temp, :temp_min, :temp_max, :feels_like, :humidity
  
  before_body {
    @weather_mutex = Mutex.new
    self.city = 'Montreal, QC, CA'
    fetch_weather!
  }
  
  body {
    shell(:no_resize) {
      grid_layout
            
      text 'Glimmer Weather'
      minimum_size 400, 300
      background DEFAULT_BACKGROUND
      
      text {
        layout_data(:center, :center, true, true)
        
        text <=> [self, :city]
        
        on_key_pressed {|event|
          if event.keyCode == swt(:cr) # carriage return
            Thread.new do
              fetch_weather!
            end
          end
        }
      }
            
      tab_folder {
        layout_data(:center, :center, true, true)
        
        ['℃', '℉'].each do |temp_unit|
          tab_item {
            grid_layout 2, false
            
            text temp_unit
            background DEFAULT_BACKGROUND
            
            rectangle(0, 0, [:default, -2], [:default, -2], 15, 15) {
              foreground DEFAULT_FOREGROUND
            }
      
            %w[temp temp_min temp_max feels_like].each do |field_name|
              temp_field(field_name, temp_unit)
            end
            
            humidity_field
          }
        end
      }
    }
  }
  
  def temp_field(field_name, temp_unit)
    name_label(field_name)
    label {
      layout_data(:fill, :center, true, false)
      text <= [self, field_name, on_read: ->(t) { "#{kelvin_to_temp_unit(t, temp_unit).to_f.round}°" }]
      font height: DEFAULT_FONT_HEIGHT
      foreground DEFAULT_FOREGROUND
    }
  end
  
  def humidity_field
    name_label('humidity')
    label {
      layout_data(:fill, :center, true, false)
      text <= [self, 'humidity', on_read: ->(h) { "#{h.to_f.round}%" }]
      font height: DEFAULT_FONT_HEIGHT
      foreground DEFAULT_FOREGROUND
    }
  end
  
  def name_label(field_name)
    label {
      layout_data :fill, :center, false, false
      text field_name.titlecase
      font height: DEFAULT_FONT_HEIGHT
      foreground DEFAULT_FOREGROUND
    }
  end
  
  def fetch_weather!
    pd 'fetch weather!'
    @weather_mutex.synchronize do
      self.weather_data = JSON.parse(Net::HTTP.get('api.openweathermap.org', "/data/2.5/weather?q=#{city}&appid=1d16d70a9aec3570b5cbd27e6b421330"))
    end
  rescue => e
    Glimmer::Config.logger.error "Unable to fetch weather due to error: #{e.full_message}"
  end
  
  def weather_data=(data)
    @weather_data = data
    main_data = data['main']
    # temps come back in Kelvin
    self.temp = main_data['temp']
    self.temp_min = main_data['temp_min']
    self.temp_max = main_data['temp_max']
    self.feels_like = main_data['feels_like']
    self.humidity = main_data['humidity']
  end
  
  def kelvin_to_temp_unit(kelvin, temp_unit)
    temp_unit == '℃' ? kelvin_to_celsius(kelvin) : kelvin_to_fahrenheit(kelvin)
  end
  
  def kelvin_to_celsius(kelvin)
    return nil if kelvin.nil?
    kelvin - 273.15
  end
  
  def celsius_to_fahrenheit(celsius)
    return nil if celsius.nil?
    (celsius * 9 / 5 ) + 32
  end
  
  def kelvin_to_fahrenheit(kelvin)
    return nil if kelvin.nil?
    celsius_to_fahrenheit(kelvin_to_celsius(kelvin))
  end
  
end

Weather.launch
