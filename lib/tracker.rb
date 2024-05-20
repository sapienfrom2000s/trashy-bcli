class Tracker < BaseService
  attr_reader :source

  def initialize(source)
    @source = source
  end
end
