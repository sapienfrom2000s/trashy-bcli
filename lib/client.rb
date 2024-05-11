class Client
  attr_reader :peers, :metainfo, :trackers

  def initialize(path)
    @metainfo = MetaInfo.new(path)
    @peers = [] # given by trackers
    # @active_peers = Queue.new # handshake was successful @trackers = group_trackers(@metainfo.trackers)
  end

  def start_download 
    @trackers = init_trackers
    Tracker.update_peer_list(@trackers[:http], peers) 
  end

  def init_trackers
    hash = { udp: [], http: [] }
    @metainfo.metadata['announce-list'].flatten.each do |tracker|
      hash[:udp] << tracker if tracker.start_with?('udp')
      hash[:http] << HTTPTracker.new(tracker, metainfo) if tracker.start_with?('http')
    end
    hash
  end
end
