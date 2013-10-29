require "fetchable"
require "delegate"

class Fetchable::Decorator < SimpleDelegator
  include Fetchable

  def [](asd)
    __getobj__[asd]
  end
end

