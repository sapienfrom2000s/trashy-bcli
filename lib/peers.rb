class Peers
  attr_accessor :list

  def initialize
    @list = []
  end

  def add(peer_data)
    @list << Peer.new(peer_data)
  end

  def peer_present?(peer_data)
    @list.any?{ |peer| peer_data.eql?(peer.peer_data) } 
  end
end
