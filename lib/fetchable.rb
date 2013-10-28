require "fetchable/version"
require "delegate"

class Fetchable < SimpleDelegator
  def initialize(collection, args={})
    @collection = collection
    @finder_method_name = args.fetch(:finder_method, :[])
    super(collection)
  end

  def fetch(key, not_found_value = no_default_given, &block)
    if not_found_value != no_default_given && block
      raise ArgumentError.new("Cannot provide both a default arg and block to #fetch")
    end

    @collection.public_send(@finder_method_name, key) || default_value(key, not_found_value, &block)
  end

  private

  def no_default_given
    @default ||= Object.new
  end

  def default_value(key, not_found_value, &block)
    if not_found_value == no_default_given
      if block
        block.call(key)
      else
        raise KeyError.new("#{key} not found in #{@collection.inspect}")
      end
    else
      not_found_value
    end
  end
end
