
# <img src="https://raw.githubusercontent.com/AndyObtiva/glimmer/master/images/glimmer-logo-hi-res.png" height=65 /> Glimmer DSL for Opal 0.0.5 (Web GUI for Desktop Apps)
[![Gem Version](https://badge.fury.io/rb/glimmer-dsl-opal.svg)](http://badge.fury.io/rb/glimmer-dsl-opal)
[![Join the chat at https://gitter.im/AndyObtiva/glimmer](https://badges.gitter.im/AndyObtiva/glimmer.svg)](https://gitter.im/AndyObtiva/glimmer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[Glimmer](https://github.com/AndyObtiva/glimmer) DSL for Opal is a web GUI adaptor for desktop apps built with [Glimmer](https://github.com/AndyObtiva/glimmer) & [Glimmer DSL for SWT](https://github.com/AndyObtiva/glimmer-dsl-swt).

It enables running [Glimmer](https://github.com/AndyObtiva/glimmer) desktop apps on the web via [Rails](https://rubyonrails.org/) 5 and [Opal](https://opalrb.com/) 1.

NOTE: Alpha Version 0.0.5 only supports capabilities for Hello samples below (detailed under [Examples](#examples)):
- [Hello, World!](#hello-world)
- [Hello, Combo!](#hello-combo)
- [Hello, Computed!](#hello-computed)
- [Hello, List Single Selection!](#hello-list-single-selection)
- [Hello, List Multi Selection!](#hello-list-multi-selection)
- [Hello, Browser!](#hello-browser)
- [Hello, Tab!](#hello-tab)

Other Glimmer DSL gems:
- [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt): Glimmer DSL for SWT (Desktop GUI)
- [glimmer-dsl-xml](https://github.com/AndyObtiva/glimmer-dsl-xml): Glimmer DSL for XML (& HTML)
- [glimmer-dsl-css](https://github.com/AndyObtiva/glimmer-dsl-css): Glimmer DSL for CSS (Cascading Style Sheets)

## Supported Glimmer DSL Keywords

The following keywords from [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt) have partial support in Opal:

- `shell`
- `label`
- `combo`
- `button`
- `text`
- `composite`
- `list` & `list(:multi)`
- `grid_layout`
- `layout_data`

## Pre-requisites

- Rails 5: [https://github.com/rails/rails/tree/5-2-stable](https://github.com/rails/rails/tree/5-2-stable)
- Opal 1: [https://github.com/opal/opal-rails](https://github.com/opal/opal-rails)

## Setup

Please follow these instructions to make Glimmer desktop apps work in Opal inside Rails 5

Start a new Rails 5 app:

```
rails new hello_world
```

Follow instructions to setup opal with a rails application: config/initializers/assets.rb

Add the following to `Gemfile` (NOTE: if you run into issues, they are probably fixed in master or development/wip branch, you may check out instead):
```
gem 'opal-rails'
gem 'opal-browser'
gem 'glimmer-dsl-opal', '~> 0.0.5', require: false
```

Edit `config/initializers/assets.rb` and add:
```
Opal.use_gem 'glimmer-dsl-opal'
```

Add the following line to the top of an empty `app/assets/javascripts/application.js.rb`

```ruby
require 'glimmer-dsl-opal' # brings opal and opal browser too
```

## Examples

### Hello, World!

Add the following Glimmer code to `app/assets/javascripts/application.js.rb`

```ruby
include Glimmer
   
shell {
  text 'Glimmer'
  label {
    text 'Hello, World!'
  }
}
```

Glimmer app on the desktop (using [`glimmer-dsl-swt`](https://github.com/AndyObtiva/glimmer-dsl-swt) gem):

![Glimmer DSL for SWT Hello World](https://github.com/AndyObtiva/glimmer/blob/master/images/glimmer-hello-world.png)

Glimmer app on the web (using `glimmer-dsl-opal` gem):

Start the Rails server:
```
rails s
```

Visit `http://localhost:3000`

You should see "Hello, World!"

![Glimmer DSL for Opal Hello World](images/glimmer-dsl-opal-hello-world.png)

### Hello, Combo!

Add the following Glimmer code to `app/assets/javascripts/application.js.rb`

```ruby
class Person
  attr_accessor :country, :country_options
  
  def initialize
    self.country_options=["", "Canada", "US", "Mexico"]
    self.country = "Canada"
  end

  def reset_country
    self.country = "Canada"
  end
end

class HelloCombo
  include Glimmer
  def launch
    person = Person.new
    shell {
      composite {
        combo(:read_only) {
          selection bind(person, :country)
        }
        button {
          text "Reset"
          on_widget_selected do
            person.reset_country
          end
        }
      }
    }.open
  end
end

HelloCombo.new.launch
```
Glimmer app on the desktop (using [`glimmer-dsl-swt`](https://github.com/AndyObtiva/glimmer-dsl-swt) gem):

![Glimmer DSL for SWT Hello Combo](https://github.com/AndyObtiva/glimmer/blob/master/images/glimmer-hello-combo.png)

Glimmer app on the web (using `glimmer-dsl-opal` gem):

Start the Rails server:
```
rails s
```

Visit `http://localhost:3000`

You should see "Hello, Combo!"

![Glimmer DSL for Opal Hello Combo](images/glimmer-dsl-opal-hello-combo.png)

### Hello, Computed!

Add the following Glimmer code to `app/assets/javascripts/application.js.rb`

```ruby
class HelloComputed
  class Contact
    attr_accessor :first_name, :last_name, :year_of_birth
  
    def initialize(attribute_map)
      @first_name = attribute_map[:first_name]
      @last_name = attribute_map[:last_name]
      @year_of_birth = attribute_map[:year_of_birth]
    end
  
    def name
      "#{last_name}, #{first_name}"
    end
  
    def age
      Time.now.year - year_of_birth.to_i
    rescue
      0
    end
  end
end

class HelloComputed
  include Glimmer

  def initialize
    @contact = Contact.new(
      first_name: "Barry",
      last_name: "McKibbin",
      year_of_birth: 1985
    )
  end

  def launch
    shell {
      text "Hello Computed"
      composite {
        grid_layout {
          num_columns 2
          make_columns_equal_width true
          horizontal_spacing 20
          vertical_spacing 10
        }
        label {text "First &Name: "}
        text {
          text bind(@contact, :first_name)
          layout_data {
            horizontalAlignment :fill
            grabExcessHorizontalSpace true
          }
        }
        label {text "&Last Name: "}
        text {
          text bind(@contact, :last_name)
          layout_data {
            horizontalAlignment :fill
            grabExcessHorizontalSpace true
          }
        }
        label {text "&Year of Birth: "}
        text {
          text bind(@contact, :year_of_birth)
          layout_data {
            horizontalAlignment :fill
            grabExcessHorizontalSpace true
          }
        }
        label {text "Name: "}
        label {
          text bind(@contact, :name, computed_by: [:first_name, :last_name])
          layout_data {
            horizontalAlignment :fill
            grabExcessHorizontalSpace true
          }
        }
        label {text "Age: "}
        label {
          text bind(@contact, :age, on_write: :to_i, computed_by: [:year_of_birth])
          layout_data {
            horizontalAlignment :fill
            grabExcessHorizontalSpace true
          }
        }
      }
    }.open
  end
end

HelloComputed.new.launch
```
Glimmer app on the desktop (using [`glimmer-dsl-swt`](https://github.com/AndyObtiva/glimmer-dsl-swt) gem):

![Glimmer DSL for SWT Hello Computed](https://github.com/AndyObtiva/glimmer/blob/master/images/glimmer-hello-computed.png)

Glimmer app on the web (using `glimmer-dsl-opal` gem):

Start the Rails server:
```
rails s
```

Visit `http://localhost:3000`

You should see "Hello, Computed!"

![Glimmer DSL for Opal Hello Computed](images/glimmer-dsl-opal-hello-computed.png)

### Hello, List Single Selection!

Add the following Glimmer code to `app/assets/javascripts/application.js.rb`

```ruby
class Person 
  attr_accessor :country, :country_options

  def initialize
    self.country_options=["", "Canada", "US", "Mexico"]
    self.country = "Canada"
  end

  def reset_country
    self.country = "Canada"
  end
end

class HelloListSingleSelection
  include Glimmer
  def launch
    person = Person.new
    shell {
      composite {
        list {
          selection bind(person, :country)
        }
        button {
          text "Reset"
          on_widget_selected do
            person.reset_country
          end
        }
      }
    }.open
  end
end

HelloListSingleSelection.new.launch
```
Glimmer app on the desktop (using [`glimmer-dsl-swt`](https://github.com/AndyObtiva/glimmer-dsl-swt) gem):

![Glimmer DSL for SWT Hello List Single Selection](https://github.com/AndyObtiva/glimmer/raw/master/images/glimmer-hello-list-single-selection.png)

Glimmer app on the web (using `glimmer-dsl-opal` gem):

Start the Rails server:
```
rails s
```

Visit `http://localhost:3000`

You should see "Hello, List Single Selection!"

![Glimmer DSL for Opal Hello List Single Selection](images/glimmer-dsl-opal-hello-list-single-selection.png)

### Hello, List Multi Selection!

Add the following Glimmer code to `app/assets/javascripts/application.js.rb`

```ruby
class Person
  attr_accessor :provinces, :provinces_options

  def initialize
    self.provinces_options=[
      "",
      "Quebec",
      "Ontario",
      "Manitoba",
      "Saskatchewan",
      "Alberta",
      "British Columbia",
      "Nova Skotia",
      "Newfoundland"
    ]
    self.provinces = ["Quebec", "Manitoba", "Alberta"]
  end

  def reset_provinces
    self.provinces = ["Quebec", "Manitoba", "Alberta"]
  end
end

class HelloListMultiSelection
  include Glimmer
  def launch
    person = Person.new
    shell {
      composite {
        list(:multi) {
          selection bind(person, :provinces)
        }
        button {
          text "Reset"
          on_widget_selected do
            person.reset_provinces
          end
        }
      }
    }.open
  end
end

HelloListMultiSelection.new.launch
```
Glimmer app on the desktop (using [`glimmer-dsl-swt`](https://github.com/AndyObtiva/glimmer-dsl-swt) gem):

![Glimmer DSL for SWT Hello List Multi Selection](https://github.com/AndyObtiva/glimmer/raw/master/images/glimmer-hello-list-multi-selection.png)

Glimmer app on the web (using `glimmer-dsl-opal` gem):

Start the Rails server:
```
rails s
```

Visit `http://localhost:3000`

You should see "Hello, List Multi Selection!"

![Glimmer DSL for Opal Hello List Multi Selection](images/glimmer-dsl-opal-hello-list-multi-selection.png)

### Hello, Browser!

Add the following Glimmer code to `app/assets/javascripts/application.js.rb`

```ruby
include Glimmer

shell {
  minimum_size 1024, 860
  browser {
    url 'http://brightonresort.com/about'
  }
}.open
```
Glimmer app on the desktop (using [`glimmer-dsl-swt`](https://github.com/AndyObtiva/glimmer-dsl-swt) gem):

![Glimmer DSL for SWT Hello Browser](https://github.com/AndyObtiva/glimmer/raw/master/images/glimmer-hello-browser.png)

Glimmer app on the web (using `glimmer-dsl-opal` gem):

Start the Rails server:
```
rails s
```

Visit `http://localhost:3000`

You should see "Hello, Browser!"

![Glimmer DSL for Opal Hello Browser](images/glimmer-dsl-opal-hello-browser.png)

### Hello, Tab!

Add the following Glimmer code to `app/assets/javascripts/application.js.rb`

```ruby
class HelloTab
  include Glimmer
  def launch
    shell {
      text "Hello, Tab!"
      tab_folder {
        tab_item {
          text "English"
          label {
            text "Hello, World!"
          }
        }
        tab_item {
          text "French"
          label {
            text "Bonjour, Univers!"
          }
        }
      }
    }.open
  end
end

HelloTab.new.launch
```
Glimmer app on the desktop (using [`glimmer-dsl-swt`](https://github.com/AndyObtiva/glimmer-dsl-swt) gem):

![Glimmer DSL for SWT Hello Tab English](https://github.com/AndyObtiva/glimmer/raw/master/images/glimmer-hello-tab-english.png)
![Glimmer DSL for SWT Hello Tab French](https://github.com/AndyObtiva/glimmer/raw/master/images/glimmer-hello-tab-french.png)

Glimmer app on the web (using `glimmer-dsl-opal` gem):

Start the Rails server:
```
rails s
```

Visit `http://localhost:3000`

You should see "Hello, Tab!"

![Glimmer DSL for Opal Hello Tab English](images/glimmer-dsl-opal-hello-tab-english.png)
![Glimmer DSL for Opal Hello Tab French](images/glimmer-dsl-opal-hello-tab-french.png)

## Help

### Issues

You may submit [issues](https://github.com/AndyObtiva/glimmer/issues) on [GitHub](https://github.com/AndyObtiva/glimmer/issues).

[Click here to submit an issue.](https://github.com/AndyObtiva/glimmer/issues)

### Chat

If you need live help, try to [![Join the chat at https://gitter.im/AndyObtiva/glimmer](https://badges.gitter.im/AndyObtiva/glimmer.svg)](https://gitter.im/AndyObtiva/glimmer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Feature Suggestions

These features have been suggested. You might see them in a future version of Glimmer. You are welcome to contribute more feature suggestions.

[TODO.md](TODO.md)

## Change Log

[CHANGELOG.md](CHANGELOG.md)

## Contributing

[CONTRIBUTING.md](CONTRIBUTING.md)

## Contributors

* [Andy Maleh](https://github.com/AndyObtiva) (Founder)

[Click here to view contributor commits.](https://github.com/AndyObtiva/glimmer-dsl-opal/graphs/contributors)

## License

Copyright (c) 2020 Andy Maleh.
See LICENSE.txt for further details.
