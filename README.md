# Fetchable

[![Gem Version](https://badge.fury.io/rb/fetchable.png)](http://badge.fury.io/rb/fetchable)
[![GitHub Actions CI](https://github.com/bestie/fetchable/actions/workflows/ci.yml/badge.svg)](https://github.com/bestie/fetchable/workflows/actions/ci.yml/badge.svg)

Ruby's `Hash#fetch` is great way to handle missing data and avoid unexpected `nil` values.

Fetchable makes it easy to add a `#fetch` method to any object that you query for data.

Both a mixin module and a decorator is provided.

There must be a `[]` method defined to access the underlying data.

The `[]` method must return anything but nil in order for `#fetch` to consider
a key successfully fetched. `False` is considered successful.

`Hash#Fetch` is one of my favourite Ruby methods but it can be tricky to implement
its full behaviour so here it is extracted for you to add to whichever object
you choose.

For details on Ruby's `Hash#fetch`, you can read some documentation
[Ruby Hash documentation](https://ruby-doc.org/3.3.5/Hash.html#method-i-fetch).

It's also available on `Array` 🤯
[Ruby Array documentation](https://ruby-doc.org/3.3.5/Array.html#method-i-fetch)

## Usage

### Mixin to your own class

```ruby
require "fetchable"

class MyDataSource
  include Fetchable

  # ...

  def [](key)
    external_datasource.get(key)
  end
end
```

### Extend an object with a `[]` method

```ruby
require "fetchable"

Thing = Struct.new(:a, :b)

a_thing = Thing.new("foo", "bar")

a_thing[:c]
# => nil

a_thing.extend(Fetchable)

a_thing.fetch(:c)
# => KeyError: key not found c

a_thing.fetch(:c) { |key| "Generate a value from #{key}" }
 => "Generate a value from c"
```

### Prefer composition over inheritance?

We got you covered! Use `Fetchable::Decorator` instead.

```ruby
require "fetchable/decorator"

Thing = Struct.new(:a, :b)

a_thing = MyStruct.new("foo", "bar")

fetchable_thing = Fetchable::Decorator.new(a_thing)

fetchable_thing.fetch(:a)
# => "foo
```

### For bonus points use lambdas

Lambdas, procs and method objects can also be called with `#[]`.

Why not make them fetchable?

It might be funny.

Dammit method, you better not return me a `nil`, I'll be so mad.

## Contributing

1. Fork it
2. Crate a pull request
3. Be nice
