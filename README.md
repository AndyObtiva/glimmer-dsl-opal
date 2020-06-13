# Glimmer DSL for Opal 0.0.1 Beta (Web GUI for Desktop Apps)
[![Gem Version](https://badge.fury.io/rb/glimmer.svg)](http://badge.fury.io/rb/glimmer)
[![Travis CI](https://travis-ci.com/AndyObtiva/glimmer.svg?branch=master)](https://travis-ci.com/github/AndyObtiva/glimmer)
[![Maintainability](https://api.codeclimate.com/v1/badges/38fbc278022862794414/maintainability)](https://codeclimate.com/github/AndyObtiva/glimmer/maintainability)

[Glimmer](https://github.com/AndyObtiva/glimmer) is a native-GUI cross-platform desktop development library written in Ruby. Glimmer's main innovation is a JRuby DSL that enables productive and efficient authoring of desktop application user-interfaces while relying on the robust Eclipse SWT library. Glimmer additionally innovates by having built-in data-binding support to greatly facilitate synchronizing the GUI with domain models. As a result, that achieves true decoupling of object oriented components, enabling developers to solve business problems without worrying about GUI concerns, or alternatively drive development GUI-first, and then write clean business models test-first afterwards.

[<img src="https://covers.oreillystatic.com/images/9780596519650/lrg.jpg" width=105 /><br /> 
Featured in<br />JRuby Cookbook](http://shop.oreilly.com/product/9780596519650.do)

## Examples

### Hello, World!

Glimmer code (from `samples/hello/hello_world.rb`):
```ruby
include Glimmer

shell {
  text "Glimmer"
  label {
    text "Hello, World!"
  }
}.open
```

Run:
```
glimmer samples/hello/hello_world.rb
```

Glimmer app:

![Hello World](images/glimmer-hello-world.png)

NOTE: Version 0.0.1 only supports Hello, World! capability of turning a Glimmer SWT desktop app into a web app that runs on Rails 5.

## Background

Ruby is a dynamically-typed object-oriented language, which provides great productivity gains due to its powerful expressive syntax and dynamic nature. While it is proven by the Ruby on Rails framework for web development, it currently lacks a robust platform-independent framework for building desktop applications. Given that Java libraries can now be utilized in Ruby code through JRuby, Eclipse technologies, such as SWT, JFace, and RCP can help fill the gap of desktop application development with Ruby.

## Pre-requisites

- Opal 1
- Rails 5

## Rails 5 Setup

Please follow these instructions to make Glimmer desktop apps work in Opal inside Rails 5

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
require 'opal'
require 'glimmer-dsl-opal'
include Glimmer
   
shell {
  text 'Hello, World!'
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
* [Dennis Theisen](https://github.com/Soleone) (Contributor)

[Click here to view contributor commits.](https://github.com/AndyObtiva/glimmer/graphs/contributors)

## License

Copyright (c) 2007-2020 Andy Maleh.
See LICENSE.txt for further details.
