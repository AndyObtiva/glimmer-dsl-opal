# Glimmer DSL for Opal 0.0.1 (Web GUI Adapter for Desktop Apps)
[![Gem Version](https://badge.fury.io/rb/glimmer-dsl-opal.svg)](http://badge.fury.io/rb/glimmer-dsl-opal)

[Glimmer](https://github.com/AndyObtiva/glimmer) DSL for Opal is a web GUI adaptor for desktop apps built with [Glimmer DSL for SWT](https://github.com/AndyObtiva/glimmer-dsl-swt).

It enables running [Glimmer](https://github.com/AndyObtiva/glimmer) desktop apps on the web via [Rails](https://rubyonrails.org/) 5 and [Opal](https://opalrb.com/) 1.

NOTE: Alpha Version 0.0.1 only supports Hello, World! capabilities.

Other Glimmer DSL gems:
- [glimmer-dsl-swt](https://github.com/AndyObtiva/glimmer-dsl-swt): Glimmer DSL for SWT (Desktop GUI)
- [glimmer-dsl-xml](https://github.com/AndyObtiva/glimmer-dsl-xml): Glimmer DSL for XML (& HTML)
- [glimmer-dsl-css](https://github.com/AndyObtiva/glimmer-dsl-css): Glimmer DSL for CSS (Cascading Style Sheets)

## Examples

### Hello, World!

Glimmer code (from `samples/hello/hello_world.rb`):
```ruby
require 'glimmer-dsl-opal'

include Glimmer

shell {
  text 'Glimmer'
  label {
    text 'Hello, World!'
  }
}.open
```

Run:
```
glimmer samples/hello/hello_world.rb
```

Glimmer app:

![Glimmer DSL for Opal Hello World](images/glimmer-dsl-opal-hello-world.png)

## Background

Ruby is a dynamically-typed object-oriented language, which provides great productivity gains due to its powerful expressive syntax and dynamic nature. While it is proven by the Ruby on Rails framework for web development, it currently lacks a robust platform-independent framework for building desktop applications. Given that Java libraries can now be utilized in Ruby code through JRuby, Eclipse technologies, such as SWT, JFace, and RCP can help fill the gap of desktop application development with Ruby.

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

Add the following to `Gemfile`:
```
gem 'opal-rails'
gem 'opal-browser'
gem 'glimmer-dsl-opal', '~> 0.0.1', require: false
```

Edit `config/initializers/assets.rb` and add:
```
Opal.use_gem 'glimmer-dsl-opal'
```

Add the following Glimmer code to `app/assets/javascripts/application.js.rb`

```ruby
require 'glimmer-dsl-opal' # brings opal and opal browser too

include Glimmer
   
shell {
  text 'Glimmer'
  label {
    text 'Hello, World!'
  }
}
```

Start the Rails server:
```
rails s
```

Visit `http://localhost:3000`

You should see "Hello, World!"

![Glimmer DSL for Opal Hello World](images/glimmer-dsl-opal-hello-world.png)

## Help

### Issues

You may submit [issues](https://github.com/AndyObtiva/glimmer/issues) on [GitHub](https://github.com/AndyObtiva/glimmer/issues).

[Click here to submit an issue.](https://github.com/AndyObtiva/glimmer/issues)

### IRC Channel

If you need live help, try the [#glimmer](http://widget.mibbit.com/?settings=7514b8a196f8f1de939a351245db7aa8&server=irc.mibbit.net&channel=%23glimmer) IRC channel on [irc.mibbit.net](http://widget.mibbit.com/?settings=7514b8a196f8f1de939a351245db7aa8&server=irc.mibbit.net&channel=%23glimmer). If no one was available, you may [leave a GitHub issue](https://github.com/AndyObtiva/glimmer/issues) to schedule a meetup on IRC. 

[Click here to connect to #glimmer IRC channel immediately via a web interface.](http://widget.mibbit.com/?settings=7514b8a196f8f1de939a351245db7aa8&server=irc.mibbit.net&channel=%23glimmer)

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
