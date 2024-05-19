class Client
  ID = 'abc123456defio896gy0' 

  attr_reader :peers, :trackers

  def initialize(path)
    $metainfo = MetaInfo.new(path).freeze
    @peers = Peers.new
    @trackers = Trackers.new(peers)
  end

  def start_download
    trackers.update_peer_list
    puts peers.list.to_s.colorize(:green)
    peers.list.each do |p|
      p.handshake
    end
  end
end
