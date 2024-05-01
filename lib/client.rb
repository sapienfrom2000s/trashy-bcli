require_relative 'metainfo'
require_relative 'http_tracker'

class Client
  def initialize(path)
    @metainfo = MetaInfo.new(path)
    @trackers = group_trackers(@metainfo.trackers)
  end

  # press against all trackers at the same time
  # In paralell what all will be happening?
  # n trackers will pull peers in paralell

  private

  def init_trackers
    @trackers[:http].each do |tracker|
      @http_trackers << HTTPTracker.new(tracker)
    end
  end

  def group_trackers(trackers)
    hash = { udp: [], http: [] }
    trackers.each do |tracker|
      tracker = tracker.first
      hash[:udp] << tracker if tracker.start_with?('udp')
      hash[:http] << tracker if tracker.start_with?('http')
    end
    hash
  end
end
