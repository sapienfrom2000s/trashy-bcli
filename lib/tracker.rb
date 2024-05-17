class Tracker < BaseService
  attr_reader :source, :metainfo

  def initialize(source, metainfo)
    @source = source
    @metainfo = metainfo
  end
end
