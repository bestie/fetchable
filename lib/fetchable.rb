module Fetchable
  def fetch(key, not_found_value = no_default_given, &block)
    if not_found_value != no_default_given && block
      raise ArgumentError.new("Cannot provide both a default arg and block to #fetch")
    end

    result = public_send(:[], key)

    if result.nil?
      default_value(key, not_found_value, &block)
    else
      result
    end
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
