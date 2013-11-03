module Fetchable
  NO_DEFAULT_GIVEN = Object.new

  def fetch(key, not_found_value = NO_DEFAULT_GIVEN)
    if not_found_value != NO_DEFAULT_GIVEN && block_given?
      raise ArgumentError.new("Cannot provide both a default arg and block to #fetch")
    end

    result = public_send(:[], key)

    if result.nil?
      return yield(key) if block_given?
      return not_found_value unless not_found_value == NO_DEFAULT_GIVEN

      raise KeyError.new("key not found #{key}")
    else
      result
    end
  end
end
