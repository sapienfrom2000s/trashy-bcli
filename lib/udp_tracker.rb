class UDPTracker < Tracker

  def initialize(source, metainfo)
    super
  end


  def request_peers
    connection_id = SecureRandom.gen_random(8)
    transaction_id = 
  end

  def peers_as_nested_array(data)
    arr = []
    data.bytes.each_slice(6) { |peer_data| arr << peer_data }
    arr
  end

  # Is this responsibility of Tracker or should we move to Peer class
  def peer_active?(address)
  end

  private

  def params_for_peer_request
    info_hash = Digest::SHA1.hexdigest(BEncode.dump(metainfo.metadata['info']))
    info_hash = [info_hash].pack('H*')

    peer_id = SecureRandom.alphanumeric(20)
    uploaded = 0
    downloaded = 0
    left = metainfo.metadata['info']['files'][0]['length']
    compact = 1

    { info_hash: info_hash, peer_id:, uploaded:, downloaded:, left:, compact: }
  end
end

