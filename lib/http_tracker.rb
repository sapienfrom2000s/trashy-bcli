class HTTPTracker < Tracker
  def peers 
    # should be broken into two parts(two methods) one to handle http request second for parsing issues
    response = Faraday.new(url: source, params: params_for_peer_request) do |faraday|
      faraday.response :raise_error
    end.get
    puts "Successfully fetched peers from #{self.source}".colorize(:green)
    parsed_response = BEncode.load(response.body)['peers']
    peers_as_nested_array(parsed_response)
  rescue StandardError => e
    $logger.error(e)
    $logger.info("Unable to fetch peers from #{source}")
    []
  end

  def peers_as_nested_array(data)
    arr = []
    data.bytes.each_slice(6){|peer_data| arr << peer_data }
    arr
  end

  # Is this responsibility of Tracker or should we move to Peer class
  def peer_active?(address)
  end
  
  private

  def params_for_peer_request
    info_hash = Digest::SHA1.hexdigest(BEncode.dump(metainfo.metadata['info']))
    info_hash = [ info_hash ].pack('H*')

    peer_id = SecureRandom.alphanumeric(20)
    uploaded = 0
    downloaded = 0
    left = metainfo.metadata['info']['files'][0]['length']
    compact = 1

    params = { info_hash: info_hash, peer_id:, uploaded:, downloaded:, left:, compact: }
  end
end

