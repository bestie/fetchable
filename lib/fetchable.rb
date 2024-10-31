module Fetchable
  NO_DEFAULT_GIVEN = Object.new

  def fetch(key, default_value = NO_DEFAULT_GIVEN)
    if default_value != NO_DEFAULT_GIVEN && block_given?
      warn("block supersedes default value argument")
    end

    result = public_send(:[], key)

    if result.nil?
      return yield(key) if block_given?
      return default_value unless default_value == NO_DEFAULT_GIVEN

      raise KeyError.new("key not found: #{key.inspect}")
    else
      result
    end
  end
end
