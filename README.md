# Fetchable

[![Gem Version](https://badge.fury.io/rb/keyword_curry.png)](http://badge.fury.io/rb/keyword_curry)

Provides a mixin and decorator to add a `Hash#fetch` like interface to any object.

You must define a `[]` subscript method for raw access to the fetchable data.

Your `[]` method must return anything but nil in order for `#fetch` to consider
a key successfully fetched. `False` is considered sucessful.

`Hash#Fetch` is one of my favourite Ruby methods and can be tricky to implement
its full behaviour so here it is extracted for you to add to whichever object
you choose.

If you're not familiar with `Hash#fetch` it's a great way to help eliminate nils
as it raises an error when the desired key is not found. For more info consult
[Ruby Hash documentation](http://www.ruby-doc.org/core-2.1.0/Hash.html#method-i-fetch).

## Installation

Add this line to your application's Gemfile:

    gem 'fetchable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fetchable

## Usage

### Include into a object with a `[]` method

```ruby

require "fetchable"

things = %w(zero one two).extend(Fetchable)

things.fetch(0)
 => "zero"

things.fetch(2)
 => "two"

things.fetch(3)
 => KeyError: key not found 3

things.fetch(3, "three")
 => "three"

things.fetch(3) { "Execute a block!" }
 => "Execute a block!"

things.fetch(3) { |key| "Do something based on missing key #{key}" }
 => "Do something based on missing key 3"

```

### Prefer composition over inheritance?

We got you covered! Use `Fetchable::Decorator` instead.

```ruby

require "fetchable/decorator"

things = %w(zero one two)

fetchable_things = Fetchable::Decorator.new(things)

fetchable_things.fetch(1)
 => "one"

```

### For bonus points use lambdas

Lambdas, procs and method objects can also be called with `#[]`.

Why not make them fetchable?

It might be funny.

Dammit method, you better not return me a `nil`, I'll be so mad.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
