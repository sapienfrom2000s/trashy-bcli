class Client
  attr_reader :peers, :metainfo, :trackers

  def initialize(path)
    @metainfo = MetaInfo.new(path)
    @peers = []
    @trackers = Trackers.new(metainfo)
  end

  def start_download
    trackers.update_peer_list(peers)
    puts peers.to_s.colorize(:green)
  end
end
