class HTTPTracker < Tracker
  def request_peers
    response = Faraday.new(url: source, params: params_for_peer_request).get
    if response.success?
      puts "Successfully fetched peers from #{source}".colorize(:green)
      peers = bencode_parse(response.body)['peers']
      peers_as_nested_array(peers)
    else
      puts "Unable to fetch peers from #{source}".colorize(:red)
      []
    end
  rescue StandardError => e
    puts e.to_s.colorize(:red)
    []
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
