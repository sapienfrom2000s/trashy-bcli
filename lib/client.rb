require 'securerandom'

class Client
  ID = SecureRandom.alphanumeric(20)

  attr_reader :peers, :trackers

  def initialize(path)
    $metainfo = MetaInfo.new(path).freeze
    @peers = Peers.new
    @trackers = Trackers.new(peers)
  end

  def start_download
    trackers.update_peer_list
    puts peers.list.to_s.colorize(:green)
    peers.list.each_slice(10) do |peer_batch|
      arr = []
      peer_batch.each do |peer|
        arr << Thread.new do
          peer.handshake
        end
      end
      arr.each(&:join)
    end
  end
end
