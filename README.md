# Fetchable

[![Gem Version](https://badge.fury.io/rb/keyword_curry.png)](http://badge.fury.io/rb/keyword_curry)

Provides a mixin to add a `Hash#fetch` like interface to any object.

You must define a `[]` subscript method for raw access to the fetchable data.

Your `[]` method must return anything but nil in order for `#fetch` to consider
a key successfully fetched. `False` is absolutely fine.

`Hash#Fetch` is one of my favourite Ruby methods and can be tricky to implement
its full behaviour so here it is extracted for you to add to whichever object
you choose.

## Installation

Add this line to your application's Gemfile:

    gem 'fetchable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fetchable

## Usage

### Include into a class with a `[]` method

```ruby

require "fetchable"


class Things
  def initialize(array)
    @array = %w(zero one two)
  end

  include Fetchable

  def [](index)
    @array[index]
  end
end

things = Things.new

things.fetch(0)
 => "zero"

things.fetch(2)
 => "two"

things.fetch(3)
 => KeyError key not found 3

things.fetch(3, "three")
 => "three"

things.fetch(3) { "Execute a block!" }
 => "Execute a block!"

things.fetch(3) { |key| "Do something based on missing key #{key}" }
 => "Do something based on missing key 3"

```

### Extend a existing object with `[]`

Add fetch to arrays, lambdas, procs and method objects.
Even a HTTP client

```ruby

function = ->(key) { |key| %w(zero one two)[key] }
fetchable_function = function.extend(Fetchable)

fetchable_function.fetch(1)
 => "one"

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
